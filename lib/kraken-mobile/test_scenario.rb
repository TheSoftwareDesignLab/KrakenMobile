require 'kraken-mobile/mobile/mobile_process'
require 'kraken-mobile/mobile/adb'
require 'kraken-mobile/models/feature_file'
require 'kraken-mobile/utils/k'
require 'parallel'

class TestScenario
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :feature_file
  attr_accessor :devices

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(feature_file_path)
    @feature_file = FeatureFile.new(file_path: feature_file_path)
    @devices = sample_devices
  end

  #-------------------------------
  # Lifecycle
  #-------------------------------
  def before_execution
    File.delete(K::DIRECTORY_PATH) if File.exist?(K::DIRECTORY_PATH)
    File.delete(K::DEVICES_READY_PATH) if File.exist?(K::DEVICES_READY_PATH)
  end

  def run
    before_execution
    execute
    after_execution
  end

  def after_execution
    File.delete(K::DIRECTORY_PATH) if File.exist?(K::DIRECTORY_PATH)
    File.delete(K::DEVICES_READY_PATH) if File.exist?(K::DEVICES_READY_PATH)
  end

  #-------------------------------
  # Methods
  #-------------------------------
  def execute
    Parallel.map_with_index(
      @devices, in_threads: @devices.count
    ) do |device, index|
      MobileProcess.new(
        id: index + 1,
        device: device,
        test_scenario: self
      ).run
    end
  end

  def self.ready_to_start?
    process_ids = DeviceProcess.registered_process_ids
    processes_ready = DeviceProcess.processes_in_state(
      K::PROCESS_STATES[:ready_to_start]
    )
    process_ids.all? do |process_id|
      processes_ready.include? process_id
    end
  end

  private

  def number_of_required_devices
    @feature_file.number_of_required_devices
  end

  def sample_devices
    devices = ADB.connected_devices
    devices.sample(number_of_required_devices)
  end
end
