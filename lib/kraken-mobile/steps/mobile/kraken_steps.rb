require 'calabash-android/calabash_steps'
require 'kraken-mobile/utils/K'
require 'kraken-mobile/models/android_device'

ParameterType(
  name: 'property',
  regexp: /[^\"]*/,
  type: String,
  transformer: lambda do |string|
    if string_is_a_property?(string)
      string.slice!('<')
      string.slice!('>')
      handle_property(string)
    elsif string_is_a_faker?(string)
      handle_faker(string)
    else
      return string
    end
  end
)

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

private

def current_process_id
  tag_process_id = @scenario_tags.grep(/@user/).first
  process_id = tag_process_id.delete_prefix('@user')
  return 'ERROR: User not foud for scenario' if process_id.nil?

  process_id
end

def string_is_a_property?(string)
  string.start_with?('<') &&
    string.end_with?('>')
end

def string_is_a_faker?(string)
  string.start_with?('$') || string.start_with?('$$')
end

def handle_property(property)
  properties = all_user_properties_as_json
  process_id = current_process_id
  user_id = "@user#{process_id}"

  if !properties[user_id] || !properties[user_id][property]
    raise "Property <#{property}> not found for @user#{current_process_id}"
  end

  properties[user_id][property]
end

def all_user_properties_as_json
  raise 'ERROR: No properties file found' if ENV['PROPERTIES_PATH'].nil?

  properties_aboslute_path = File.expand_path(ENV['PROPERTIES_PATH'])
  raise 'ERROR: Properties file not found' unless File.file?(
    properties_aboslute_path
  )

  file = open(properties_aboslute_path)
  content = file.read
  JSON.parse(content)
end

def handle_faker(faker)
  nil
end
