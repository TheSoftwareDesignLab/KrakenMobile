
#-------------------------------
# Helpers
#-------------------------------
def ensure_apk_is_specified
  if ARGV.empty? || !is_apk_file?(ARGV.first)
    puts "The first parameter must be the path to a valid apk file."
    exit 1
  end
end

def ensure_configuration_is_valid configuration
  if !File.exist?(configuration) && !File.file?(configuration) && !configuration.end_with?(".json")
    puts "The path of the configuration file is not valid."
    exit 1
  end
end

#-------------------------------
# Command reader
#-------------------------------

@features_dir = File.join(FileUtils.pwd, "features")
@support_dir = File.join(@features_dir, "support")
@source_dir = File.join(File.dirname(__FILE__), '..', 'calabash-android-features-skeleton')

def handle_calabash_android cmd, protocol, configuration
  case cmd
    when 'gen'
      require File.join(File.dirname(__FILE__), "kraken-mobile-generate")
      kraken_scaffold()
    when 'resign'
      require 'calabash-android/helpers'
      ensure_apk_is_specified
      puts "Resigning APK with Calabash-Android"
      resign_apk(File.expand_path(ARGV.first))
    when 'run'
      require 'kraken-mobile/constants'
      require 'calabash-android/helpers'
      options = {
        cucumber_options: "--format pretty",
        feature_folder: @features_dir,
        runner: KrakenMobile::Constants::CALABASH_ANDROID,
        protocol: protocol
      }
      if configuration
        ensure_configuration_is_valid File.expand_path(configuration)
        # User needs to resign the apps that is going to use manually with kraken-mobile ressign <APK>
        options[:config_path] = File.expand_path(configuration)
      else
        ensure_apk_is_specified
        options[:apk_path] = ARGV.first
        #resign_apk(File.expand_path(ARGV.first)) TODO Resign app
      end
      kraken = KrakenMobile::App.new(options)
      kraken.run_in_parallel
    else
      puts "Invalid command '#{cmd}'"
      print_usage
  end
end
