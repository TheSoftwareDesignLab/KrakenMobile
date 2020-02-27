require 'rubygems'
require 'fileutils'

#-------------------------------
# Helpers
#-------------------------------

def print_usage
  puts <<USAGE
  Usage: kraken-mobile <command-name> [parameters] [options]
  <command-name> can be one of
    run <apk>
      runs Cucumber in the current folder with the environment needed.
    version
      prints the gem version.
    devices
      prints the list of devices attached.
    setup
      creates kraken-settings file specifying in what devices the tests are going to be run.
    gen
      generate a features folder structure.
    resign <apk>
      resigns the app with the currently configured keystore.
USAGE
end

def print_devices
  puts 'List of devices attached'
  ADB.connected_devices.each_with_index do |device, index|
    puts "user#{index + 1} - #{device}"
  end
end

def apk_file?(file_path)
  file_path.end_with?('.apk') && File.exist?(file_path)
end

def relative_to_full_path(file_path)
  File.expand_path(file_path)
end

def msg(title, &block)
  puts "\n" + '-' * 10 + title + '-' * 10
  block.call
  puts '-' * 10 + '-------' + '-' * 10 + "\n"
end

def scaffold_folder_structure
  if File.exist?(@features_dir)
    puts 'A features directory already exists. Stopping...'
    exit 1
  end

  msg('Question') do
    puts 'I\'m about to create a subdirectory called features.'
    puts 'features will contain all your kraken tests.'
    puts 'Please hit return to confirm that\'s what you want.'
  end
  exit 2 unless STDIN.gets.chomp == ''

  FileUtils.cp_r(@source_dir, @features_dir)

  msg('Info') do
    puts "features subdirectory created. \n"
  end
end
