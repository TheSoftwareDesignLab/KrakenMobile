require 'kraken-mobile/helpers/feature_analyzer'
require 'kraken-mobile/mobile/mobile_process'
require 'kraken-mobile/models/feature_file'
require 'kraken-mobile/models/web_device'
require 'kraken-mobile/web/web_process'
require 'kraken-mobile/utils/reporter'
require 'kraken-mobile/mobile/adb'
require 'kraken-mobile/utils/k.rb'
require 'parallel'

class TestScenario
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :devices
  attr_accessor :kraken_app
  attr_accessor :feature_file
  attr_accessor :execution_id
  attr_accessor :reporter

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(kraken_app:, feature_file_path:)
    @feature_file = FeatureFile.new(file_path: feature_file_path)
    @devices = sample_devices
    @kraken_app = kraken_app
    @execution_id = Digest::SHA256.hexdigest(Time.now.to_f.to_s)
    @reporter = Reporter.new(test_scenario: self)

    ensure_apk_specified_if_necessary
  end

  #-------------------------------
  # Lifecycle
  #-------------------------------
  def before_execution
    setup_scenario_environment_variables
    delete_all_web_inboxes
    File.delete(K::DIRECTORY_PATH) if File.exist?(K::DIRECTORY_PATH)
    File.delete(K::DICTIONARY_PATH) if File.exist?(K::DICTIONARY_PATH)
    K::PROCESS_STATE_FILE_PATH.each do |_state, file_path|
      File.delete(file_path) if File.exist?(file_path)
    end
    @reporter.create_report_folder_requirements
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
    File.delete(K::DICTIONARY_PATH) if File.exist?(K::DICTIONARY_PATH)
    K::PROCESS_STATE_FILE_PATH.each do |_state, file_path|
      File.delete(file_path) if File.exist?(file_path)
    end
    @reporter.save_report
    notify_scenario_finished
  end

  #-------------------------------
  # Methods
  #-------------------------------
  def execute
    Parallel.map_with_index(
      @devices, in_threads: @devices.count
    ) do |device, index|
      unless device.nil?
        user_id = index + 1
        start_process_for_user_id_in_device(
          user_id, device
        )
      end
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

  def requires_predefined_devices?
    !ENV[K::CONFIG_PATH].nil?
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
    return predefined_devices if requires_predefined_devices?

    mobile = sample_mobile_devices
    web = sample_web_devices
    @feature_file.sorted_required_devices.map do |device|
      device[:system_type] == '@web' ? web.shift : mobile.shift
    end
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

  def delete_all_web_inboxes
    Dir.glob(".*_#{K::INBOX_FILE_NAME}").each do |file|
      File.delete(file)
    end
  end

  def predefined_devices
    config_absolute_path = File.expand_path(ENV[K::CONFIG_PATH])
    file = open(config_absolute_path)
    content = file.read
    file.close
    devices_json = JSON.parse(content).values
    devices_json.map do |device_json|
      if device_json['type'] == K::ANDROID_DEVICE
        AndroidDevice.new(
          id: device_json['id'], model: device_json['model']
        )
      elsif device_json['type'] == K::WEB_DEVICE
        WebDevice.new(
          id: device_json['id'], model: device_json['model']
        )
      else
        raise 'ERROR: Platform not supported'
      end
    end
  end

  def apk_required?
    sample_mobile_devices.any? && ENV[K::CONFIG_PATH].nil?
  end

  def ensure_apk_specified_if_necessary
    return unless apk_required?
    return unless @kraken_app&.apk_path.nil?

    raise 'ERROR: Invalid APK file path'
  end

  def setup_scenario_environment_variables
    return if @kraken_app.nil? || @reporter.nil?

    @kraken_app.save_value_in_environment_variable_with_name(
      name: K::SCREENSHOT_PATH, value: @reporter.screenshot_path
    )
  end
end
