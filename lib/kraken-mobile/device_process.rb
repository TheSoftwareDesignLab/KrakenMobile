# Abstract class
class DeviceProcess
  attr_accessor :id
  attr_accessor :device
  attr_accessor :test_scenario

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(id:, device:, test_scenario:)
    @id = id
    @device = device
    @test_scenario = test_scenario
  end

  #-------------------------------
  # Required methods
  #-------------------------------
  def before_execute
    raise 'ERROR: before_execute not implemented.'
  end

  def execute
    raise 'ERROR: execute not implemented.'
  end

  def after_execute
    raise 'ERROR: after_execute not implemented.'
  end

  def run
    before_execute
    execute
    after_execute
  end

  #-------------------------------
  # Methods
  #-------------------------------
  def self.directory
    return [] unless File.exist?(K::DIRECTORY_PATH)

    directory = nil
    File.open(K::DIRECTORY_PATH, 'r') do |file|
      directory = file.each_line.map(&:to_s)
    end

    directory || []
  end
end
