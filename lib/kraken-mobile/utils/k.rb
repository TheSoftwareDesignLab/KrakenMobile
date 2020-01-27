# frozen_string_literal: true

module K
  SEPARATOR = ';' unless defined? SEPARATOR
  DIRECTORY_PATH = '.device_directory' unless defined? DIRECTORY_PATH
  INBOX_FILE_NAME = 'inbox.txt' unless defined? INBOX_FILE_NAME
  FEATURES_PATH = './features' unless defined? FEATURES_PATH
  DEFAULT_TIMEOUT_SECONDS = 30 unless defined? DEFAULT_TIMEOUT_SECONDS

  unless defined? DEFAULT_START_TIMEOUT_SECONDS
    DEFAULT_START_TIMEOUT_SECONDS = 600 # 10.minutes
  end

  unless defined? DEFAULT_FINISH_TIMEOUT_SECONDS
    DEFAULT_FINISH_TIMEOUT_SECONDS = 600 # 10.minutes
  end

  unless defined? DEVICES_READY_PATH
    DEVICES_READY_PATH = '.devices_ready_to_start'
  end

  unless defined? DEVICES_FINISHED_PATH
    DEVICES_FINISHED_PATH = '.devices_ready_to_finish'
  end

  unless defined? PROCESS_STATES
    PROCESS_STATES = {
      ready_to_start: 0,
      ready_to_finish: 1
    }.freeze
  end

  unless defined? PROCESS_STATE_FILE_PATH
    PROCESS_STATE_FILE_PATH = {
      K::PROCESS_STATES[:ready_to_start] => DEVICES_READY_PATH,
      K::PROCESS_STATES[:ready_to_finish] => DEVICES_FINISHED_PATH
    }.freeze
  end
end
