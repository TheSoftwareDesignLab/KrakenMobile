require 'calabash-android/environment_helpers.rb'
require 'calabash-android/monkey_helpers'
require 'calabash-android/operations'

module AndroidMonkey
  include Calabash::Android::Operations
  include Calabash::Android::MonkeyHelpers

  def execute_monkey(number_of_events)
    height, width = screen_size
    start_monkey

    number_of_events.times do |_i|
      monkey_touch(
        K::CALABASH_MONKEY_ACTIONS.sample,
        rand(5..(width - 5)),
        rand(5..(height - 5))
      )
    end

    kill_existing_monkey_processes
  end

  private

  # Override calabash super adb_command method
  def adb_command
    calabash_default_device.adb_command
  end
end
