require 'calabash-android/management/adb'
require 'calabash-android/operations'

Before do |scenario|
  install_app_with_calabash()
  @scenario_tags = scenario.source_tag_names
end

After do |scenario|
  @scenario_tags = scenario.source_tag_names
end

AfterStep do |scenario|
  screenshot_embed
end
