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
  # Constructors
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
