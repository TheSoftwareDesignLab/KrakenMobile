require 'calabash-android/calabash_steps'

Then(/^I send a signal to user (\d+) containing "([^\"]*)"$/) do |_int, _string|
  puts 'Hi'
end

Then(/^I wait for a signal containing "([^\"]*)"$/) do |_string|
  puts 'Bye'
end
