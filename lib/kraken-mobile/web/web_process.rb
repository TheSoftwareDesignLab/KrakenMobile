require 'kraken-mobile/device_process.rb'

class WebProcess < DeviceProcess
  #-------------------------------
  # Required methods
  #-------------------------------
  def before_execute
    register_process_to_directory
    device.create_inbox
  end

  def after_execute
    unregister_process_from_directory
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

    "|cucumber #{feature_path} --tags @user#{id} \
    --require features/web/step_definitions/web_steps.rb \
    --require features/web/support/app_life_cycle_hooks.rb \
    --format pretty --format json -o \
    #{K::REPORT_PATH}/#{@test_scenario.execution_id}/#{device.id}/#{K::FILE_REPORT_NAME}"
  end
end
