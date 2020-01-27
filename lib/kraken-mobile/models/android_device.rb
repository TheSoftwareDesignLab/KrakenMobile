require 'kraken-mobile/models/device'
require 'kraken-mobile/mobile/adb'

class AndroidDevice < Device
  #-------------------------------
  # Signaling
  #-------------------------------
  def create_inbox
    raise 'ERROR: Device is disconnected.' unless connected?

    ADB.create_file_with_name_in_device(
      device_id: @id,
      file_name: K::INBOX_FILE_NAME
    )
  end

  def delete_inbox
    raise 'ERROR: Device is disconnected.' unless connected?

    ADB.delete_file_with_name_in_device(
      device_id: @id,
      file_name: K::INBOX_FILE_NAME
    )
  end

  def write_signal(signal)
    ADB.write_content_to_file_with_name_in_device(
      content: signal,
      device_id: @id,
      file_name: K::INBOX_FILE_NAME
    )
  end

  def read_signal(signal)
    Timeout.timeout(K::DEFAULT_TIMEOUT_SECONDS, RuntimeError) do
      sleep(1) until inbox_last_signal == signal
    end
  end

  def connected?
    ADB.connected_devices.any? do |device|
      device.id == @id
    end
  end

  #-------------------------------
  # Helprs
  #-------------------------------
  private

  def inbox_last_signal
    ADB.file_content(device_id: @id, file_name: K::INBOX_FILE_NAME).strip
  end
end
