require 'kraken-mobile/models/device'
require 'kraken-mobile/mobile/adb'
require 'kraken-mobile/monkeys/mobile/kraken_android_monkey'
require 'kraken-mobile/monkeys/mobile/android_monkey'

class AndroidDevice < Device
  include KrakenAndroidMonkey
  include AndroidMonkey

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

  #-------------------------------
  # More interface methods
  #-------------------------------
  def connected?
    ADB.connected_devices.any? do |device|
      device.id == @id
    end
  end

  def orientation
    ADB.device_orientation(
      device_id: @id
    ).strip!.to_i
  rescue StandardError => _e
    K::ANDROID_PORTRAIT
  end

  def screen_size
    size = ADB.device_screen_size(device_id: @id)

    height = orientation == K::ANDROID_PORTRAIT ? size[1] : size[0]
    width = orientation == K::ANDROID_PORTRAIT ? size[0] : size[1]

    [height, width]
  end

  #-------------------------------
  # Random testing
  #-------------------------------
  def run_monkey_with_number_of_events(number_of_events)
    execute_monkey(number_of_events)
  end

  def run_kraken_monkey_with_number_of_events(number_of_events)
    execute_kraken_monkey(number_of_events)
  end

  #-------------------------------
  # Helprs
  #-------------------------------
  def calabash_default_device
    operations_module = Calabash::Android::Operations
    operations_module::Device.new(
      operations_module,
      ENV['ADB_DEVICE_ARG'],
      ENV['TEST_SERVER_PORT'],
      ENV['APP_PATH'],
      ENV['TEST_APP_PATH']
    )
  end

  private

  def inbox_last_signal
    ADB.file_content(device_id: @id, file_name: K::INBOX_FILE_NAME).strip
  end
end
