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

      def run_small_monkey channel, number_of_events, height_start, height_end, width_start, width_end
        devices_helper = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]}).device_helper
        device_id = channel_to_device_id channel
        height, width = devices_helper.screen_size device_id
        start_monkey
        actions = [:move, :down, :up]
        numb_height_start = (height*(height_start/100.0)).to_i+5
        numb_height_end = (height*(height_end/100.0)).to_i-5
        numb_width_start = (width*(width_start/100.0)).to_i+5
        numb_width_end = (width*(width_end/100.0)).to_i-5
        number_of_events.times do |i|
          pos_x = rand(numb_width_start..numb_width_end)
          pos_y = rand(numb_height_start..numb_height_end)
          monkey_touch(actions.sample,pos_x,pos_y)
        end
        kill_existing_monkey_processes
      end
    end
  end
end
