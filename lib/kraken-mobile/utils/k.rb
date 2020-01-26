# frozen_string_literal: true

# TODO, Fix use of defined?
module K
  SEPARATOR = ';' unless defined? SEPARATOR
  DIRECTORY_PATH = '.device_directory' unless defined? DIRECTORY_PATH
  unless defined? DEVICES_READY_PATH
    DEVICES_READY_PATH = '.devices_ready_to_start'
  end
  INBOX_FILE_NAME = 'inbox.txt' unless defined? INBOX_FILE_NAME
  FEATURES_PATH = './features' unless defined? FEATURES_PATH
end
