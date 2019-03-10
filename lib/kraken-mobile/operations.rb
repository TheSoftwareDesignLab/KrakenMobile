require 'kraken-mobile/helpers/devices_helper/adb_helper'

module KrakenMobile
  module Operations
    def readSignal(channel, content, timeout)
      devices_helper = DevicesHelper::AdbHelper.new()
      device_id = channel_to_device_id(channel)
      while(devices_helper.read_file_content("inbox", device_id) != content)
        sleep(1)
      end
    end

    def writeSignal(channel, content)
      devices_helper = DevicesHelper::AdbHelper.new()
      device_id = channel_to_device_id(channel)
      devices_helper.write_content_to_file(content, "inbox", device_id)
    end

    # helpers
    def channel_to_device_id channel
      begin
        channel.slice!("@user")
        device_position = channel.to_i - 1
        devices_helper = DevicesHelper::AdbHelper.new()
        devices_helper.connected_devices[device_position].id
      rescue
        nil
      end
    end
  end
end
