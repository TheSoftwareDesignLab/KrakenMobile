#-------------------------------
# Command reader
#-------------------------------

@features_dir = File.join(FileUtils.pwd, "features")
@support_dir = File.join(@features_dir, "support")
@source_dir = File.join(File.dirname(__FILE__), '..', 'features-skeleton')

def handle_calabash_android protocol
  cmd = ARGV.shift
  case cmd
    when 'gen'
      require File.join(File.dirname(__FILE__), "kraken-mobile-generate")
      kraken_scaffold()
    when 'run'
      if ARGV.empty? or not is_apk_file?(ARGV.first)
        puts "The first parameter must be the path to the apk file."
        exit 1
      else
        require 'kraken-mobile/constants'
        options = {
          apk_path: ARGV.first,
          cucumber_options: "--format pretty",
          feature_folder: @features_dir,
          runner: KrakenMobile::Constants::CALABASH_ANDROID,
          protocol: KrakenMobile::Constants::FILE_PROTOCOL
        }
        kraken = KrakenMobile::App.new(options)
        kraken.run_in_parallel
      end
    when 'version'
      require 'kraken-mobile/version'
      puts KrakenMobile::VERSION
    when 'devices'
      require 'kraken-mobile/helpers/devices_helper/adb_helper'
      print_devices
    else
      puts "Invalid command '#{cmd}'"
      print_usage
  end
end
