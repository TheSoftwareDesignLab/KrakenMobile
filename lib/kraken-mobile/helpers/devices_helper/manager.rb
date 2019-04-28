require 'kraken-mobile/models/device'
require 'kraken-mobile/helpers/devices_helper/adb_helper'
require 'kraken-mobile/constants'
require 'json'

module KrakenMobile
	module DevicesHelper
    class Manager
      def initialize(options)
        @runner_name = options[:runner]
        @config_path = options[:config_path]
      end

      def connected_devices
        if @config_path
          raise "The path of the configuration file is not valid" unless File.exist?(@config_path) && File.file?(@config_path) && @config_path.end_with?(".json")
          file = open(@config_path)
          content = file.read
          configured_devices = JSON.parse(content)
          devices = []
          configured_devices.each do |dev_data|
            device = Models::Device.new(dev_data["id"], dev_data["model"], devices.size + 1, dev_data["config"])
            devices << device
          end
          devices
        else
          device_helper.connected_devices
        end
      end

      def device_helper
        case @runner_name
        when KrakenMobile::Constants::CALABASH_ANDROID
          DevicesHelper::AdbHelper.new()
        when KrakenMobile::Constants::MONKEY
          DevicesHelper::AdbHelper.new()
        else
          raise "Runner is not supported"
        end
      end
    end
	end
end
