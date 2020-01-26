require 'kraken-mobile/models/device'

class AndroidDevice < Device
  def write_signal(signal)
    puts signal
  end

  def read_signal(signal)
    puts signal
  end
end
