require 'kraken-mobile/models/device'

module KrakenMobile
	module DevicesHelper
		class AdbHelper
      # ADB command that returns all phones and emulators connected to the computer.
			def adb_devices_l
				`adb devices -l`
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
								device = Models::Device.new(line_id, line_model)
								devices << device
							end
						end
					devices
				rescue
					[]
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
