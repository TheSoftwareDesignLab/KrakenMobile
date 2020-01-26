require 'kraken-mobile/models/device'
require 'kraken-mobile/constants'
require 'kraken-mobile/adb_commands.rb'

class ADB
  class << self
    include Android::Commands

    def connected_devices
      devices = []
      adb_devices_l.split("\n").each do |line|
        id = extract_device_id(line)
        model = extract_device_model(line)
        next if id.nil? || model.nil?

        devices << KrakenMobile::Models::Device.new(id, model)
      end
      devices
    rescue StandardError => _e
      raise 'ERROR: Can\'t read Android devices connected.'
    end

    private

    def extract_device_id(line)
      return line.split(' ').first if line.match(/device(?!s)/)
    end

    def extract_device_model(line)
      return unless line.match(/device(?!s)/)

      line.scan(/model:(.*) device/).flatten.first
    end
  end
end
