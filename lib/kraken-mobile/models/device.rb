require 'kraken-mobile/device_process'

class Device
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :id
  attr_accessor :model

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(id:, model:)
    @id = id
    @model = model
  end

  #-------------------------------
  # Signaling
  #-------------------------------
  def create_inbox
    raise 'ERROR: create_inbox not implemented.'
  end

  def delete_inbox
    raise 'ERROR: delete_inbox not implemented.'
  end

  def write_signal(_signal)
    raise 'ERROR: write_signal not implemented.'
  end

  def read_signal(_signal, _timeout = K::DEFAULT_TIMEOUT_SECONDS)
    raise 'ERROR: read_signal not implemented.'
  end

  #-------------------------------
  # Random testing
  #-------------------------------
  def run_monkey_with_number_of_events(_number_of_events)
    raise 'ERROR: run_monkey_with_number_of_events not implemented.'
  end

  def run_kraken_monkey_with_number_of_events(_number_of_events)
    raise 'ERROR: run_kraken_monkey_with_number_of_events not implemented.'
  end

  #-------------------------------
  # More interface methods
  #-------------------------------
  def connected?
    raise 'ERROR: connected? not implemented.'
  end

  def orientation
    raise 'ERROR: orientation not implemented.'
  end

  def screen_size
    raise 'ERROR: screen_size not implemented.'
  end

  def sdk_version
    raise 'ERROR: sdk_version not implemented.'
  end

  def type
    raise 'ERROR: Unsupported device'
  end

  def save_snapshot_in_path(_file_path)
    raise 'ERROR: save_snapshot_in_path not implemented.'
  end

  #-------------------------------
  # Helpers
  #-------------------------------
  def to_s
    @id + K::SEPARATOR + @model + K::SEPARATOR + type
  end

  def screenshot_prefix
    @id.gsub('.', '_').gsub(/:(.*)/, '').to_s + '_'
  end

  def self.find_by_process_id(id)
    DeviceProcess.directory.each do |process_info|
      info = process_info.strip.split(K::SEPARATOR)
      process_id = info[0]
      next unless process_id.to_s == id.to_s

      return device_from_type(
        id: info[1], model: info[2],
        device_type: info[3]
      )
    end

    nil
  end

  def self.device_from_type(id:, model:, device_type:)
    device_class = nil
    if device_type == K::ANDROID_DEVICE
      device_class = AndroidDevice
    elsif device_type == K::WEB_DEVICE
      device_class = WebDevice
    end
    raise 'ERROR: Unsupported device' if device_class.nil?

    device_class.new(
      id: id, model: model
    )
  end
end
