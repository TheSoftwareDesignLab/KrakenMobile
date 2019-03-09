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
      prints the gem version
EOF
end

def is_apk_file?(file_path)
    file_path.end_with? ".apk" and File.exist? file_path
end

def relative_to_full_path(file_path)
    File.expand_path(file_path)
end
