require 'calabash-android/calabash_steps'
require 'kraken-mobile/utils/k.rb'
require 'kraken-mobile/models/android_device'
require 'kraken-mobile/steps/general_steps'

Then(
  /^I send a signal to user (\d+) containing "([^\"]*)"$/
) do |process_id, signal|
  device = Device.find_by_process_id(process_id)
  raise 'ERROR: Device not found' if device.nil?
  if process_id.to_s == current_process_id.to_s
    raise 'ERROR: Can\'t send signal to same device'
  end

  device.write_signal(signal)
end

Then(/^I wait for a signal containing "([^\"]*)"$/) do |signal|
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.nil?
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.grep(/@user/).none?

  device = Device.find_by_process_id(current_process_id)
  raise 'ERROR: Device not found' if device.nil?

  device.read_signal(signal)
end

Then(
  /^I wait for a signal containing "([^\"]*)" for (\d+) seconds$/
) do |signal, seconds|
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.nil?
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.grep(/@user/).none?

  device = Device.find_by_process_id(current_process_id)
  raise 'ERROR: Device not found' if device.nil?

  device.read_signal(signal, seconds)
end

Then(/^I start a monkey with (\d+) events$/) do |number_of_events|
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.nil?
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.grep(/@user/).none?

  device = Device.find_by_process_id(current_process_id)
  raise 'ERROR: Device not found' if device.nil?

  device.run_monkey_with_number_of_events(number_of_events)
end

Then(/^I start kraken monkey with (\d+) events$/) do |number_of_events|
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.nil?
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.grep(/@user/).none?

  device = Device.find_by_process_id(current_process_id)
  raise 'ERROR: Device not found' if device.nil?

  device.run_kraken_monkey_with_number_of_events(number_of_events)
end

Then(/^I save device snapshot in file with path "([^\"]*)"$/) do |file_path|
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.nil?
  raise 'ERROR: Invalid scenario tag' if @scenario_tags.grep(/@user/).none?

  device = Device.find_by_process_id(current_process_id)
  raise 'ERROR: Device not found' if device.nil?

  device.save_snapshot_in_file_path(file_path)
end

Then(/^I enter text "([^\"]*)"$/) do |text|
  keyboard_enter_text(text, {})
end
