require 'kraken-mobile/runners/calabash/android/kraken_steps'

Then(/^I hide my keyboard$/) do
  hide_soft_keyboard()
end

Then /^I enter password "([^\"]*)"$/ do |text|
  enter_text(text)
end

Then /^I enter email "([^\"]*)"$/ do |text|
  enter_text(text)
end

Then /^I enter answer "([^\"]*)"$/ do |text|
  enter_text(text)
end

Then /^I enter question "([^\"]*)"$/ do |text|
  enter_text(text)
end

Then "I open answers tab" do
  tap_when_element_exists("* id:'customInboxTabIcon' index:1")
end
