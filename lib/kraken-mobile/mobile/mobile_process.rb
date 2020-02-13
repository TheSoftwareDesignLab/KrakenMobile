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

    apk_path = '~/Desktop/app.apk' # TODO, load good
    raise 'ERROR: Invalid APK file path' if apk_path.nil?

    "|ADB_DEVICE_ARG=#{device.id} calabash-android run #{apk_path} \
    #{feature_path} --tags @user#{id}"
  end
end
