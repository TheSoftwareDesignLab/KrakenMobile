require 'kraken-mobile/device_process.rb'

class MobileProcess < DeviceProcess
  #-------------------------------
  # Required methods
  #-------------------------------
  def before_execute
    register_process_to_directory
    device.create_inbox
  end

  def after_execute
    device.delete_inbox
  end

  def execute
    open(execution_command, 'r') do |output|
      loop do
        $stdout.print output.readline.to_s
        $stdout.flush
      end
    end
    $CHILD_STATUS.exitstatus
  rescue EOFError
    nil
  end

  private

  def execution_command
    feature_path = test_scenario.feature_file.file_path
    raise 'ERROR: Invalid feature file path' if feature_path.nil?

    process_apk_path = apk_path
    raise 'ERROR: Invalid APK file path' if process_apk_path.nil?

    "|ADB_DEVICE_ARG=#{device.id} calabash-android run #{process_apk_path} \
    #{feature_path} --tags @user#{id}"
  end

  #-------------------------------
  # Helpers
  #-------------------------------

  def apk_path
    return config_apk_path if @test_scenario.requires_predefined_devices?

    path = @test_scenario&.kraken_app&.apk_path
    raise 'ERROR: Invalid APK file path' if path.nil?

    path
  end

  def config_json
    config_absolute_path = File.expand_path(ENV[K::CONFIG_PATH])
    file = open(config_absolute_path)
    content = file.read
    JSON.parse(content)[@id.to_s] || {}
  end

  def config_apk_path
    device_config_json = config_json
    return if device_config_json['config'].nil?
    return if device_config_json['config']['apk_path'].nil?

    absolute_config_apk_path = File.expand_path(
      device_config_json['config']['apk_path']
    )

    raise 'ERROR: Invalid config apk path' unless File.file?(
      absolute_config_apk_path
    )

    absolute_config_apk_path
  end
end
