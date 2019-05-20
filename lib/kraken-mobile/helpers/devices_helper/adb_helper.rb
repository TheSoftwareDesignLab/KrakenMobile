require 'kraken-mobile/models/device'
require 'kraken-mobile/constants'

module KrakenMobile
	module DevicesHelper
		class AdbHelper
      # ADB command that returns all phones and emulators connected to the computer.
			def adb_devices_l
				`adb devices -l`
			end

      def file_content file_name, device_id
        `adb -s #{device_id} shell "cat /sdcard/#{file_name} 2> /dev/null"`
      end

      def write_content_to_device content, file_name, device_id
        `adb -s #{device_id} shell "echo "#{content}" > /sdcard/#{file_name}"`
      end

      def create_file_in_device file_name, device_id
        `adb -s #{device_id} shell "> /sdcard/#{file_name}"`
      end

      def delete_file_in_device file_name, device_id
        `adb -s #{device_id} shell "rm -rf /sdcard/#{file_name}"`
      end

      def device_screen_size device_id
        `adb -s #{device_id} shell wm size`
      end

      def device_sdk_version device_id
        `adb -s #{device_id} shell getprop ro.build.version.sdk`
      end

      def device_orientation device_id
        `adb -s #{device_id} shell dumpsys input | grep 'SurfaceOrientation' | awk '{ print $2 }'`
      end

      def is_device_connected device_id
        begin
         adb_devices_l.include?(device_id)
        rescue
          false
        end
      end

      # Returns an array with all the devices and emulators connected to the computer.
			def connected_devices
				begin
					devices = []
					list =
						adb_devices_l.split("\n").each do |line|
							line_id = extract_device_id(line)
							line_model = extract_device_model(line)
							if line_id && line_model
								device = Models::Device.new(line_id, line_model, devices.size + 1)
								devices << device
							end
						end
					devices
				rescue
					[]
				end
			end

      def read_file_content file_name, device_id
        begin
          raise "Device #{device_id} not found" unless is_device_connected(device_id)
          content = file_content("#{file_name}.txt", device_id)
          content.strip
        rescue
          ""
        end
      end

      def write_content_to_file content, file_name, device_id
        begin
          raise "Device #{device_id} not found" unless is_device_connected(device_id)
          write_content_to_device(content, "#{file_name}.txt", device_id)
          true
        rescue
          false
        end
      end

      def create_file file_name, device_id
        begin
          raise "Device #{device_id} not found" unless is_device_connected(device_id)
          create_file_in_device("#{file_name}.txt", device_id)
          true
        rescue
          false
        end
      end

      def delete_file file_name, device_id
        begin
          raise "Device #{device_id} not found" unless is_device_connected(device_id)
          delete_file_in_device("#{file_name}.txt", device_id)
          true
        rescue
          false
        end
      end

      # Returns height, width
      def screen_size device_id
        begin
          adb_size = device_screen_size device_id
          parts = adb_size.strip!.split(" ")
          size = parts[parts.count-1]
          return 0,0 if !size.include?("x")
          size_parts = size.split("x")
          if orientation(device_id) == KrakenMobile::Constants::PORTRAIT
            return size_parts[1].to_i, size_parts[0].to_i
          else
            return size_parts[0].to_i, size_parts[1].to_i
          end
        rescue
          return 0,0
        end
      end

      def sdk_version device_id
        begin
          return device_sdk_version device_id
        rescue
          return "N/A"
        end
      end

      def orientation device_id
        begin
          adb_orientation = device_orientation(device_id).strip!
          return adb_orientation.to_i
        rescue
          return KrakenMobile::Constants::PORTRAIT
        end
      end

      # Parses the device id from the ADB devices command.
			def extract_device_id line
				if line.match(/device(?!s)/)
					line.split(" ").first
				end
			end

      # Parses the device model from the ADB devices command.
			def extract_device_model line
				if line.match(/device(?!s)/)
					line.scan(/model:(.*) device/).flatten.first
				end
			end
		end
	end
end
