ParameterType(
  name:        'property',
  regexp:      /[^\"]*/,
  type:        String,
  transformer: ->(s) {
    if ENV["PROPERTIES_PATH"]
      raise "Property #{s} should start with '<' and end with '>'" if !s.start_with?("<") || ! s.end_with?(">")
      s.slice!("<")
      s.slice!(">")
      file = open(ENV["PROPERTIES_PATH"])
      content = file.read
      properties = JSON.parse(content)
      raise "Property <#{s}> not found" if !properties[s]
      return properties[s]
    else
      return s
    end
  }
)

Then("I wait for a signal containing {string}") do |string|
  channel = @scenario_tags.grep(/@user/).first
  readSignal(channel, string, KrakenMobile::Constants::DEFAULT_TIMEOUT)
end

Then("I wait for a signal containing {string} for {int} seconds") do |string, int|
  channel = @scenario_tags.grep(/@user/).first
  readSignal(channel, string, int)
end

Then("I send a signal to user {int} containing {string}") do |int, string|
  writeSignal("@user#{int}", string)
end
