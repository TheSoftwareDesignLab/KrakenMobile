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
    raise 'ERROR: Empty direcotry' unless File.exist?(K::DIRECTORY_PATH)

    File.open(K::DIRECTORY_PATH, 'r') do |file|
      file.each_line.each do |line|
        directory_info = line.strip.split(';') # TODO, change for separator
        process_id = directory_info[0]

        return AndroidDevice.new(id: directory_info[1], model: nil) if process_id.to_s == id.to_s
      end
    end
    nil
  end
end
