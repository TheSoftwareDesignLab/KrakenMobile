ParameterType(
  name:        'property',
  regexp:      /[^\"]*/,
  type:        String,
  transformer: ->(s) {
    channel = @scenario_tags.grep(/@user/).first
    if ENV["PROPERTIES_PATH"] && channel && s.start_with?("<") && s.end_with?(">")
      s.slice!("<")
      s.slice!(">")
      file = open(ENV["PROPERTIES_PATH"])
      content = file.read
      file.close
      properties = JSON.parse(content)
      raise "Property <#{s}> not found for #{channel}" if !properties[channel] || !properties[channel][s]
      return properties[channel][s]
    else
      return s
    end
  }
)

ParameterType(
  name:        'property',
  regexp:      /[^\"]*/,
  type:        String,
  transformer: ->(s) {
    channel = @scenario_tags.grep(/@user/).first
    if ENV["PROPERTIES_PATH"] && channel && s.start_with?("<") && s.end_with?(">")
      s.slice!('$')
      return properties[channel][s]
    else
      return s
    end
  }
)

Then /^I wait for a signal containing "([^\"]*)"$/ do |string|
  channel = @scenario_tags.grep(/@user/).first
  readSignal(channel, string, KrakenMobile::Constants::DEFAULT_TIMEOUT)
end

Then /^I wait for a signal containing "([^\"]*)" for (\d+) seconds$/ do |string, int|
  channel = @scenario_tags.grep(/@user/).first
  readSignal(channel, string, int)
end

Then /^I wait for any signal for (\d+) seconds$/ do |int|
  channel = @scenario_tags.grep(/@user/).first
  readAnySignal(channel, int)
end

Then /^I send a signal to user (\d+) containing "([^\"]*)"$/ do |int, string|
  writeSignal("@user#{int}", string)
end

#Then /^I send a signal to any user containing "([^\"]*)"$/ do |string|
#  writeSignalToAnyDevice(string)
#end

Then /^I start a monkey with (\d+) events$/ do |int|
  channel = @scenario_tags.grep(/@user/).first
  run_monkey channel, int
end

Then /^I start kraken monkey with (\d+) events$/ do |int|
  channel = @scenario_tags.grep(/@user/).first
  run_kraken_monkey channel, int
end

Then /^I start a monkey with (\d+) events from height (\d+)% to (\d+)% and width (\d+)% to (\d+)%$/ do |int, from_x, to_x, from_y, to_y|
  channel = @scenario_tags.grep(/@user/).first
  run_small_monkey channel, int, from_x, to_x, from_y, to_y
end
