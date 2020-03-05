require 'kraken-mobile/helpers/feature_analyzer'
require 'kraken-mobile/mobile/mobile_process'
require 'kraken-mobile/models/feature_file'
require 'kraken-mobile/models/web_device'
require 'kraken-mobile/web/web_process'
require 'kraken-mobile/mobile/adb'
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
    unless @feature_file.right_syntax?
      raise "ERROR: Verify feature file #{@file_path} has one unique @user tag"\
      ' for each scenario'
    end

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
      user_id = index + 1
      start_process_for_user_id_in_device(
        user_id,
        device
      )
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

  def start_process_for_user_id_in_device(user_id, device)
    if device.is_a? AndroidDevice
      start_mobile_process_for_user_id_in_device(user_id, device)
    elsif device.is_a? WebDevice
      start_web_process_for_user_id_in_device(user_id, device)
    else
      raise 'ERROR: Platform not supported'
    end
  end

  def start_mobile_process_for_user_id_in_device(user_id, device)
    MobileProcess.new(
      id: user_id,
      device: device,
      test_scenario: self
    ).run
  end

  def start_web_process_for_user_id_in_device(user_id, device)
    WebProcess.new(
      id: user_id,
      device: device,
      test_scenario: self
    ).run
  end

  def sample_devices
    (sample_mobile_devices + sample_web_devices).flatten
  end

  def sample_mobile_devices
    android_devices = ADB.connected_devices
    android_devices.sample(
      @feature_file.number_of_required_mobile_devices
    )
  end

  def sample_web_devices
    web_devices = []
    @feature_file.number_of_required_web_devices.times do
      web_devices << WebDevice.factory_create
    end
    web_devices
  end

  def notify_scenario_finished
    @kraken_app.on_test_scenario_finished
  end

  def user_id_is_mobile?(user_id)
    complement_tags = @feature_file.tags_for_user_id(user_id).map(
      &:downcase
    )
    complement_tags.include?('@mobile')
  end

  def user_id_is_web?(user_id)
    complement_tags = @feature_file.tags_for_user_id(user_id).map(
      &:downcase
    )
    complement_tags.include?('@web')
  end
end
