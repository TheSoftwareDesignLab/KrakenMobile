require 'kraken-mobile/device_process.rb'

class MobileProcess < DeviceProcess
  def initialize; end

  def execute_process
    # TODO, Change command
    open("|ADB_DEVICE_ARG=#{device.id} calabash-android run ~/Desktop/app.apk --tags @user#{id}", 'r') do |output|
      loop do
        $stdout.print output.readline.to_s
        $stdout.flush
      end
    end
    $CHILD_STATUS.exitstatus
  rescue EOFError
    nil
  end
end
