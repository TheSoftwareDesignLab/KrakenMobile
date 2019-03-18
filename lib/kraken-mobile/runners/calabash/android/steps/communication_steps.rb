Then("I wait for a signal containing {string}") do |string|
  channel = @scenario_tags.grep(/@user/).first
  readSignal(channel, string, 10)
end

Then("I send a signal to user {int} containing {string}") do |int, string|
  writeSignal("@user#{int}", string)
end
