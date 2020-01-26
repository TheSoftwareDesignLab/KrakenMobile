require 'kraken-mobile/helpers/devices_helper/adb_helper.rb' # TODO, Remove this
require 'kraken-mobile/mobile_process.rb'
require 'kraken-mobile/adb.rb'
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
    Parallel.map(devices, in_threads: 1) do |_device|
      process = MobileProcess.new
      process.test_scenario = self
      process.execute_process
    end
  end
end
