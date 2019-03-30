require "rubygems"
require 'fileutils'

#-------------------------------
# Helpers
#-------------------------------

def print_usage
  puts <<EOF
  Usage: kraken-mobile <command-name> [parameters] [options]
  <command-name> can be one of
    run <apk>
      runs Cucumber in the current folder with the environment needed.
    version
      prints the gem version.
    devices
      prints the list of devices attached.
EOF
end

def print_devices
  runner = KrakenMobile::Constants::CALABASH_ANDROID
  device_manager = KrakenMobile::DevicesHelper::Manager.new({runner: runner})
  puts "List of devices attached"
  device_manager.connected_devices.each_with_index do |device, index|
    puts "user#{index+1} - #{device.id} - #{device.model}"
  end
end

def is_apk_file?(file_path)
    file_path.end_with? ".apk" and File.exist? file_path
end

def relative_to_full_path(file_path)
    File.expand_path(file_path)
end

def msg(title, &block)
  puts "\n" + "-"*10 + title + "-"*10
  block.call
  puts "-"*10 + "-------" + "-"*10 + "\n"
end
