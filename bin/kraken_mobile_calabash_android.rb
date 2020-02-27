@features_dir = File.join(FileUtils.pwd, 'features')
@support_dir = File.join(@features_dir, 'support')
@source_dir = File.join(
  File.dirname(__FILE__),
  '..',
  'calabash-android-features-skeleton'
)

def handle_calabash_android(configuration, properties)
  require 'kraken-mobile/constants'
  require 'calabash-android/helpers'
  options = {
    feature_folder: @features_dir,
  }
  #if configuration
  #  ensure_configuration_is_valid File.expand_path(configuration)
  #  options[:config_path] = File.expand_path(configuration)
  #else
  #  ensure_apk_is_specified
  #  options[:apk_path] = ARGV.first
  #end
  #if properties
  #  ensure_properties_is_valid File.expand_path(properties)
  #  options[:properties_path] = File.expand_path(properties)
  #end
  kraken = KrakenApp.new
  kraken.start
end
