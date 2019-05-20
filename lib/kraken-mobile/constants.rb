module KrakenMobile
  module Constants
    # Runners
    CALABASH_ANDROID = "calabash-android"
    MONKEY = "monkey"
    REPORT_PATH = "./reports"
    REPORT_DEVICES_FILE_NAME = "devices"
    REPORT_FILE_NAME = "report"
    D3_DATA_FILE_NAME = "data"

    # Protocols
    FILE_PROTOCOL = "file-based"
    SUPPORTED_PROTOCOLS = [FILE_PROTOCOL]

    # Protocol
    DEVICE_INBOX_NAME = "inbox"
    KRAKEN_CONFIGURATION_FILE_NAME = "kraken_settings"
    DEFAULT_TIMEOUT = 10
    MONKEY_DEFAULT_TIMEOUT = 5

    # ADB Orientations
    PORTRAIT = 0
    LANDSCAPE = 1
  end
end
