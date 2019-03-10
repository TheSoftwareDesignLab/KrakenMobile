require 'kraken-mobile/helpers/devices_helper/adb_helper'

module KrakenMobile
  module Operations
    def readSignal(channel, content, timeout)
      devices_helper = DevicesHelper::AdbHelper.new()
      while(devices_helper.read_file_content("inbox", channel) != content)
        sleep(1)
      end
    end

    def writeSignal(channel, content)
      devices_helper = DevicesHelper::AdbHelper.new()
      devices_helper.write_content_to_file(content, "inbox", channel)
    end
  end
end
