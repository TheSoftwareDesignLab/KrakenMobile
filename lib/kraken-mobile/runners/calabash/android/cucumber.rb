require 'calabash-android/cucumber'
require 'calabash-android/operations'
require 'kraken-mobile/runners/calabash/android/kraken_hooks'
require 'kraken-mobile/runners/calabash/android/operations'
require 'kraken-mobile/runners/calabash/android/monkey_helper'
require 'kraken-mobile/constants'
require 'kraken-mobile/protocols/file_protocol'

def requested_protocol
  case ENV["PROTOCOL"]
  when KrakenMobile::Constants::FILE_PROTOCOL
    KrakenMobile::Protocol::FileProtocol
  else
    raise "Invalid Kraken protocol."
  end
end

World(Calabash::Android::ColorHelper)
World(Calabash::Android::Operations)
World(KrakenMobile::CalabashAndroid::Operations)
World(KrakenMobile::CalabashAndroid::MonkeyHelper)
World(requested_protocol())

AfterConfiguration do
  require 'calabash-android/calabash_steps'
  require 'kraken-mobile/runners/calabash/android/kraken_steps'
end
