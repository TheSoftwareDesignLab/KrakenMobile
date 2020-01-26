require 'kraken-mobile/models/device'
require 'kraken-mobile/mobile/adb'

class AndroidDevice < Device
  #-------------------------------
  # Signaling
  #-------------------------------
  def create_inbox
    raise 'ERROR: Device is disconnected.' unless connected?

    device_id = @id
    ADB.create_file_with_name_in_device(device_id, K::INBOX_FILE_NAME)
  end

  def delete_inbox
    raise 'ERROR: Device is disconnected.' unless connected?

    device_id = @id
    ADB.delete_file_with_name_in_device(device_id, K::INBOX_FILE_NAME)
  end

  def write_signal(signal)
    puts signal
  end

  def read_signal(signal)
    puts signal
  end

  #-------------------------------
  # Helprs
  #-------------------------------
  private

  def connected?
    ADB.connected_devices.any? do |device|
      device.id == @id
    end
  end
end
