require 'kraken-mobile/models/device'

class WebDevice < Device
  #-------------------------------
  # Signaling
  #-------------------------------
  def create_inbox
    file = File.open(inbox_file_path, 'w')
    file.close
  end

  def delete_inbox
    return unless File.exist? inbox_file_path

    File.delete(inbox_file_path)
  end

  def write_signal(signal)
    File.open(inbox_file_path, 'a') do |file|
      file.puts(signal)
    end
  end

  def read_signal(signal, timeout = K::DEFAULT_TIMEOUT_SECONDS)
    Timeout.timeout(timeout, RuntimeError) do
      sleep(1) until inbox_last_signal == signal
    end
  end

  #-------------------------------
  # More interface methods
  #-------------------------------
  def connected?
    true
  end

  def orientation
    K::WEB_PORTRAIT
  end

  def screen_size
    height = 0
    width = 0

    [height, width]
  end

  def sdk_version
    1.0 # Default
  end

  def type
    K::WEB_DEVICE
  end

  #-------------------------------
  # Random testing
  #-------------------------------
  def run_monkey_with_number_of_events(number_of_events)
    number_of_events # TODO, implement
  end

  def run_kraken_monkey_with_number_of_events(number_of_events)
    number_of_events # TODO, implement
  end

  #-------------------------------
  # Helpers
  #-------------------------------
  def self.factory_create
    WebDevice.new(
      id: SecureRandom.hex(10),
      model: 'Web'
    )
  end

  private

  def inbox_file_path
    ".#{@id}_#{K::INBOX_FILE_NAME}"
  end

  def inbox_last_signal
    file = File.open(inbox_file_path)
    lines = file.to_a
    file.close
    lines.last&.strip
  end
end
