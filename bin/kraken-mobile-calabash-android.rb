#-------------------------------
# Command reader
#-------------------------------

@features_dir = File.join(FileUtils.pwd, "features")
@support_dir = File.join(@features_dir, "support")
@source_dir = File.join(File.dirname(__FILE__), '..', 'features-skeleton')

def handle_calabash_android cmd, protocol
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
          protocol: protocol
        }
        kraken = KrakenMobile::App.new(options)
        kraken.run_in_parallel
      end
    else
      puts "Invalid command '#{cmd}'"
      print_usage
  end
end
