require 'kraken-mobile/mobile/mobile_process.rb'
require 'kraken-mobile/mobile/adb.rb'
require 'parallel'

class TestScenario
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :feature_file_path

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(feature_file_path)
    @feature_file_path = feature_file_path
  end

  #-------------------------------
  # Methods
  #-------------------------------
  def execute
    devices = ADB.connected_devices
    Parallel.map_with_index(
      devices, in_threads: devices.count
    ) do |device, index|
      process = MobileProcess.new
      process.id = index + 1 # Start from 1
      process.test_scenario = self
      process.device = device
      process.execute_process
    end
  end
end
