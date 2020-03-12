require 'kraken-mobile/models/android_device'
require 'kraken-mobile/constants'
require 'kraken-mobile/mobile/android_commands.rb'

class ADB
  class << self
    include Android::Commands

    def connected_devices
      devices = []
      adb_devices_l.split("\n").each do |line|
        id = extract_device_id(line)
        model = extract_device_model(line)
        next if id.nil? || model.nil?

        devices << AndroidDevice.new(id: id, model: model)
      end
      devices
    rescue StandardError => _e
      raise 'ERROR: Can\'t read Android devices connected.'
    end

    def device_screen_size(device_id:)
      adb_size = screen_size_for_device_with_id(device_id: device_id)
      extract_device_screen_size_info(adb_size)
    rescue StandardError => _e
      raise "ERROR: Can\'t read Android device #{device_id} screen size."
    end

    def save_snapshot_for_device_with_id_in_file_path(device_id:, file_path:)
      save_snapshot_for_device_with_id_in_path(
        device_id: device_id,
        file_path: file_path
      )
    rescue StandardError => _e
      raise "ERROR: Can\'t save snapshot for device #{device_id}."
    end

    def device_sdk_version(device_id:)
      version = sdk_version_for_device_with_id(device_id: device_id)
      version.strip
    rescue StandardError => _e
      raise "ERROR: Can\'t get SDK version for device #{device_id}."
    end

    private

    def extract_device_id(line)
      return line.split(' ').first if line.match(/device(?!s)/)
    end

    def extract_device_model(line)
      return unless line.match(/device(?!s)/)

      line.scan(/model:(.*) device/).flatten.first
    end

    def extract_device_screen_size_info(line)
      parts = line.strip!.split(' ')
      size = parts[parts.count - 1]
      return [0, 0] unless size.include?('x')

      size.split('x').map(&:to_i)
    end
  end
end
