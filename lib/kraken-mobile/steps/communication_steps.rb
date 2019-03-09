Then /^I wait for a signal$/ do
  readSignal("algo", 10)
end

Then /^I send a signal$/ do
  writeSignal("algo", "Posiasfljaf")
end
