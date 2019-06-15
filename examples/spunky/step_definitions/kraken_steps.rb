require 'kraken-mobile/runners/calabash/android/kraken_steps'

Then /^I send a signal to user (\d+) containing the game code$/ do |index|
  code = query("* id:'textViewCodigo'")[0]["text"]
  writeSignal("@user#{index}", "CODE:#{code}")
end

Then "I wait for game code and enter it" do
  signal = readSignalWithKeyworkd("@user2","CODE:",60)
  signal.slice!("CODE:")
  enter_text(signal)
end

Then /^I enter username "([^\"]*)"$/ do |text|
  enter_text(text)
end

Then(/^I hide my keyboard$/) do
  hide_soft_keyboard()
end
