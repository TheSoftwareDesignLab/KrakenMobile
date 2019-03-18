require 'calabash-android/management/adb'
require 'calabash-android/operations'

Before do |scenario|
  install_app_with_calabash()
  @scenario_tags = scenario.source_tag_names
  channel = @scenario_tags.grep(/@user/).first
  start_test_server_in_background
  start_setup(channel, scenario)
end

After do |scenario|
  @scenario_tags = scenario.source_tag_names
  channel = @scenario_tags.grep(/@user/).first
  end_setup channel, scenario
  if scenario.failed?
    screenshot_embed
  end
  shutdown_test_server
  uninstall_app_with_calabash
end
