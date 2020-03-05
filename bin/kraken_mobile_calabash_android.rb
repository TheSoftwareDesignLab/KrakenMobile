@features_dir = File.join(FileUtils.pwd, 'features')
@support_dir = File.join(@features_dir, 'support')
@source_dir = File.join(
  File.dirname(__FILE__),
  '..',
  'calabash-android-features-skeleton'
)

def handle_calabash_android(configuration, properties_path)
  require 'kraken-mobile/constants'
  require 'calabash-android/helpers'
  #options = {}
  #if configuration
  #  ensure_configuration_is_valid File.expand_path(configuration)
  #  options[:config_path] = File.expand_path(configuration)
  #else
  #  ensure_apk_is_specified
  #  options[:apk_path] = ARGV.first
  #end
  kraken = KrakenApp.new(
    apk_path: user_entered_apk_path,
    properties_path: format_properties(properties_path)
  )
  kraken.start
end

private

def format_properties(properties_path)
  return if properties_path.nil?

  properties_absolute_path = File.expand_path(properties_path)
  ensure_properties_is_valid(properties_absolute_path)

  properties_absolute_path
end
