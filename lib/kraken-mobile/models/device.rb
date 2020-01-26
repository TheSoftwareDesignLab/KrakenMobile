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
  # Helpers
  #-------------------------------
  def screenshot_prefix
    @id.gsub('.', '_').gsub(/:(.*)/, '').to_s + '_'
  end

  def write_signal(_signal)
    raise 'ERROR: write_signal not implemented.'
  end

  def read_signal(_signal)
    raise 'ERROR: read_signal not implemented.'
  end

  def self.find_by_process_id(id)
    DeviceProcess.directory.each do |process_info|
      info = process_info.strip.split(K::SEPARATOR)
      process_id = info[0]
      next unless process_id.to_s == id.to_s

      return AndroidDevice.new(
        id: info[1], model: info[2]
      )
    end

    nil
  end
end
