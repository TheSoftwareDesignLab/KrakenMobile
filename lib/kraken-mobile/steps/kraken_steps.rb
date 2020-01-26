require 'calabash-android/calabash_steps'
require 'kraken-mobile/utils/K'
require 'kraken-mobile/models/android_device'

Then(/^I send a signal to user (\d+) containing "([^\"]*)"$/) do |process_id, signal|
  device = Device.find_by_process_id(process_id)
  device.write_signal(signal)
end

Then(/^I wait for a signal containing "([^\"]*)"$/) do |_string|
  puts 'Bye'
end
