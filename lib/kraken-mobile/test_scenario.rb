require 'kraken-mobile/mobile/mobile_process'
require 'kraken-mobile/mobile/adb'
require 'kraken-mobile/utils/k'
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
  # Lifecycle
  #-------------------------------
  def before_execution
    File.delete(K::DIRECTORY_PATH) if File.exist?(K::DIRECTORY_PATH)
  end

  def run
    before_execution
    execute
    after_execution
  end

  def after_execution; end

  #-------------------------------
  # Methods
  #-------------------------------
  def execute
    devices = ADB.connected_devices
    Parallel.map_with_index(
      devices, in_threads: devices.count
    ) do |device, index|
      process = MobileProcess.new(
        id: index + 1,
        device: device,
        test_scenario: self
      )
      #process.execute_process
    end
  end
end
