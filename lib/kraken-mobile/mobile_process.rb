require 'kraken-mobile/device_process.rb'

class MobileProcess < DeviceProcess
  def initialize; end

  def execute_process
    # TODO, Change command
    open('|calabash-android run ~/Desktop/app.apk', 'r') do |output|
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
