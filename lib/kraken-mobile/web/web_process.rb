require 'kraken-mobile/device_process.rb'

class WebProcess < DeviceProcess
  #-------------------------------
  # Required methods
  #-------------------------------
  def before_execute
    register_process_to_directory
    #device.create_inbox
  end

  def after_execute
    #device.delete_inbox
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

    url_path = 'www.google.com'
    raise 'ERROR: Invalid URL path' if url_path.nil?

    "|cucumber"
  end
end
