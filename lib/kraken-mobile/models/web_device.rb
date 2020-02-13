require 'kraken-mobile/models/device'

class WebDevice < Device
  #-------------------------------
  # Signaling
  #-------------------------------
  def create_inbox
  end

  def delete_inbox
  end

  def write_signal(signal)
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
  end

  def run_kraken_monkey_with_number_of_events(number_of_events)
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
  end
end
