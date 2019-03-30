require 'kraken-mobile/models/device'
require 'kraken-mobile/helpers/devices_helper/adb_helper'
require 'kraken-mobile/constants'

module KrakenMobile
	module DevicesHelper
    class Manager
      def initialize(runner)
        @runner = runner
      end

      def connected_devices
        puts "Hola"
      end

      def device_helper
        case @runner
        when KrakenMobile::Constants::CALABASH_ANDROID
          DevicesHelper::AdbHelper.new()
        else
          raise "Runner is not supported"
        end
      end
    end
	end
end
