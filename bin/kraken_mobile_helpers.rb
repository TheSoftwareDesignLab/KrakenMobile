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
    puts "user#{index + 1} - #{device.to_s.split(K::SEPARATOR).join(' - ')}"
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

def ensure_apk_is_specified
  return if !ARGV.empty? && apk_file?(ARGV.first)

  puts 'The first parameter must be the path to a valid apk file.'
  exit 1
end

def ensure_configuration_is_valid(configuration)
  return if File.exist?(configuration) &&
            File.file?(configuration) &&
            configuration.end_with?('.json')

  puts 'The path of the configuration file is not valid.'
  exit 1
end

def ensure_properties_is_valid(properties)
  return if File.exist?(properties) &&
            File.file?(properties) &&
            properties.end_with?('.json')

  puts 'The path of the properties file is not valid.'
  exit 1
end

def ensure_android_sdk_installed
  return unless ENV['ANDROID_HOME'].nil?

  puts 'To use Kraken you need to have installed Android SDK first. '\
        'Make sure you have the environment variable ANDROID_HOME configured'
  exit 1
end

def ensure_java_installed
  return unless ENV['ANDROID_HOME'].nil?

  puts 'To use Kraken you need to have installed Java first.'\
        'Make sure you have the environment variable JAVA_HOME configured'
  exit 1
end
