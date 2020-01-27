require 'kraken-mobile/mobile/mobile_process'
require 'kraken-mobile/mobile/adb'
require 'kraken-mobile/models/feature_file'
require 'kraken-mobile/utils/k'
require 'parallel'

class TestScenario
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :devices
  attr_accessor :kraken_app
  attr_accessor :feature_file

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(kraken_app:, feature_file_path:)
    @feature_file = FeatureFile.new(file_path: feature_file_path)
    @devices = sample_devices
    @kraken_app = kraken_app
  end

  #-------------------------------
  # Lifecycle
  #-------------------------------
  def before_execution
    File.delete(K::DIRECTORY_PATH) if File.exist?(K::DIRECTORY_PATH)
    K::PROCESS_STATE_FILE_PATH.each do |_state, file_path|
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  def run
    before_execution
    execute
    after_execution
  end

  def after_execution
    File.delete(K::DIRECTORY_PATH) if File.exist?(K::DIRECTORY_PATH)
    K::PROCESS_STATE_FILE_PATH.each do |_state, file_path|
      File.delete(file_path) if File.exist?(file_path)
    end
    notify_scenario_finished
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
      processes_ready.include?(process_id) ||
        Device.find_by_process_id(process_id)&.connected? == false
    end
  end

  def self.ready_to_finish?
    process_ids = DeviceProcess.registered_process_ids
    processes_finished = DeviceProcess.processes_in_state(
      K::PROCESS_STATES[:ready_to_finish]
    )
    process_ids.all? do |process_id|
      processes_finished.include?(process_id) ||
        Device.find_by_process_id(process_id)&.connected? == false
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

  def notify_scenario_finished
    @kraken_app.on_test_scenario_finished
  end
end
