require 'kraken-mobile/models/device'

class WebDevice < Device
  #-------------------------------
  # Signaling
  #-------------------------------
  def create_inbox
    File.open(".#{@id}_#{K::INBOX_FILE_NAME}", 'w')
  end

  def delete_inbox
    file_name = ".#{@id}_#{K::INBOX_FILE_NAME}"
    return unless File.exist? file_name

    File.delete(file_name)
  end

  def write_signal(signal)
    signal # TODO, implement
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
  # Helprs
  #-------------------------------
  def self.factory_create
    WebDevice.new(
      id: SecureRandom.hex(10),
      model: 'Web'
    )
  end

  private

  def inbox_last_signal
    'test' # TODO, implement
  end
end
