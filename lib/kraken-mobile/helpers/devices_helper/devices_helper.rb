require 'kraken-mobile/models/device'
require 'kraken-mobile/helpers/devices_helper/adb_helper'
require 'kraken-mobile/constants'

module KrakenMobile
	module DevicesHelper
    def self.current_device_helper runner
      case runner
      when KrakenMobile::Constants::CALABASH_ANDROID
        DevicesHelper::AdbHelper.new()
      else
        raise "Runner is not supported"
      end
    end
	end
end
