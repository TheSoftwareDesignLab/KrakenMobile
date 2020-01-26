require 'calabash-android/calabash_steps'
require 'kraken-mobile/utils/K'
require 'kraken-mobile/models/android_device'

Then(/^I send a signal to user (\d+) containing "([^\"]*)"$/) do |process_id, signal|
  device = Device.find_by_process_id(process_id)
  raise 'ERROR: Device not found' if device.nil?

  device.write_signal(signal)
end

Then(/^I wait for a signal containing "([^\"]*)"$/) do |signal|
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.nil?
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.grep(/@user/).none?

  tag_process_id = @scenario_tags.grep(/@user/).first
  process_id = tag_process_id.delete_prefix('@user')
  device = Device.find_by_process_id(process_id)
  raise 'ERROR: Device not found' if device.nil?

  device.read_signal(signal)
end
