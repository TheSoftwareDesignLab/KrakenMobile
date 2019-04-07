require 'calabash-android/monkey_helpers'

module KrakenMobile
  module CalabashAndroid
    module MonkeyHelper
      def run_monkey channel, number_of_events
        devices_helper = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]}).device_helper
        device_id = channel_to_device_id channel
        height, width = devices_helper.screen_size device_id
        start_monkey
        actions = [:move, :down, :up]
        number_of_events.times do |i|
          monkey_touch(actions.sample, rand(5..(width-5)) , rand(5..(height-5)))
        end
        kill_existing_monkey_processes
      end
    end
  end
end
