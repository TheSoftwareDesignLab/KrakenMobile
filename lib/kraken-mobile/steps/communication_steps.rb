Then /^I wait for a signal$/ do
  readSignal("93c6af534id", "signal", 10)
end

Then /^I send a signal$/ do
  writeSignal("93c6af5234id", "signal")
end
