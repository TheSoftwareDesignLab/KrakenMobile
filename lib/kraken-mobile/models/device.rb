class Device
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :id
  attr_accessor :model

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(id, model)
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
end
