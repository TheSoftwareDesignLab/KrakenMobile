# frozen_string_literal: true

module K
  SEPARATOR = ';' unless defined? SEPARATOR
  DIRECTORY_PATH = '.device_directory' unless defined? DIRECTORY_PATH
  DICTIONARY_PATH = 'dictionary.json' unless defined? DICTIONARY_PATH
  INBOX_FILE_NAME = 'inbox.txt' unless defined? INBOX_FILE_NAME
  FEATURES_PATH = './features' unless defined? FEATURES_PATH
  DEFAULT_TIMEOUT_SECONDS = 30 unless defined? DEFAULT_TIMEOUT_SECONDS
  ANDROID_PORTRAIT = 0 unless defined? ANDROID_PORTRAIT
  ANDROID_LANDSCAPE = 1 unless defined? ANDROID_LANDSCAPE
  WEB_PORTRAIT = 1 unless defined? WEB_PORTRAIT
  MONKEY_DEFAULT_TIMEOUT = 5 unless defined? MONKEY_DEFAULT_TIMEOUT
  WEB_DEVICE = 'WEB_DEVICE' unless defined? WEB_DEVICE
  ANDROID_DEVICE = 'ANDROID_DEVICE' unless defined? ANDROID_DEVICE
  PROPERTIES_PATH = 'PROPERTIES_PATH' unless defined? PROPERTIES_PATH
  CONFIG_PATH = 'CONFIG_PATH' unless defined? CONFIG_PATH
  REPORT_PATH = './reports' unless defined? REPORT_PATH
  FILE_REPORT_NAME = 'report.json' unless defined? FILE_REPORT_NAME
  D3_DATA_FILE_NAME = 'data.json' unless defined? D3_DATA_FILE_NAME
  SCREENSHOT_PATH = 'SCREENSHOT_PATH' unless defined? SCREENSHOT_PATH

  unless defined? DEVICES_REPORT_FILE_NAME
    DEVICES_REPORT_FILE_NAME = 'devices.json'
  end

  unless defined? REPORT_ASSETS_PATH
    REPORT_ASSETS_PATH = '../../../../reporter/assets/'
  end

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

  unless defined? CALABASH_MONKEY_ACTIONS
    CALABASH_MONKEY_ACTIONS = [
      :move,
      :down,
      :up
    ].freeze
  end
end
