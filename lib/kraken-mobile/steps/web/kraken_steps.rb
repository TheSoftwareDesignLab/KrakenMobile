require 'kraken-mobile/monkeys/web/web_monkey'
require 'kraken-mobile/steps/general_steps'
require 'kraken-mobile/utils/k.rb'
require 'selenium-webdriver'
require 'uri'

Before do
  @driver = Selenium::WebDriver.for((ENV['BROWSER'] || 'chrome').to_sym)
end

Given(/^I navigate to page "([^\"]*)"$/) do |web_url|
  raise 'ERROR: Invalid URL' if web_url.nil?
  raise 'ERROR: Invalid URL' unless web_url =~ URI::DEFAULT_PARSER.make_regexp

  @driver.navigate.to web_url
  sleep 2
end

Then(/^I enter "([^\"]*)" into input field having id "([^\"]*)"$/) do |text, id|
  @driver.find_element(:id, id).send_keys(text)
  sleep 2
end

Then(
  /^I enter "([^\"]*)" into input field having css selector "([^\"]*)"$/
) do |text, selector|
  @driver.find_element(:css, selector).send_keys(text)
  sleep 2
end

Then(/^I click on element having id "(.*?)"$/) do |id|
  @driver.find_element(:id, id).click
  sleep 2
end

Then(/^I wait$/) do
  sleep 5
end

Then(/^I wait for (\d+) seconds$/) do |seconds|
  return if seconds.nil?

  sleep seconds.to_i
end

Then(/^I should see text "(.*?)"$/) do |text|
  @driver.page_source.include?(text)
end

Then(/^I click on element having css selector "(.*?)"$/) do |selector|
  @driver.find_element(:css, selector).click
  sleep 2
end

Then(
  /^I select option with value "(.*?)" for dropdown with id "(.*?)"$/
) do |op_value, sel_id|
  drop = @driver.find_element(:id, sel_id)
  choose = Selenium::WebDriver::Support::Select.new(drop)
  choose.select_by(:value, op_value)
  sleep 2
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
  monkey = WebMonkey.new(driver: @driver)
  monkey.execute_kraken_monkey(number_of_events)
end

# Hooks
AfterStep do |_scenario|
  path = "#{ENV[K::SCREENSHOT_PATH]}/#{SecureRandom.hex(12)}.png"
  @driver.save_screenshot(path)
  embed(path, 'image/png', File.basename(path))
end
