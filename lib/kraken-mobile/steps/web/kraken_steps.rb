require 'selenium-webdriver'
require 'faker'

driver = Selenium::WebDriver.for :firefox

Given(/^We navigate to the homepage$/) do
  driver.navigate.to 'http://mock.agiletrailblazers.com/'
end

When(/^We search for the word agile$/) do
  sleep 5
  driver.find_element(:id, 's').send_keys('buenas')
  sleep 5
  driver.find_element(:id, 'submit-button').click
end

Then(/^The results for the search will be displayed$/) do
  sleep 10
end

# Kraken Steps
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

private

def current_process_id
  tag_process_id = @scenario_tags.grep(/@user/).first
  tag_process_id.delete_prefix('@user')
end
