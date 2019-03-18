require 'calabash-android/cucumber'
require 'calabash-android/operations'
require 'kraken-mobile/runners/calabash/android/operations'
require 'kraken-mobile/runners/calabash/android/kraken_hooks'

World(Calabash::Android::ColorHelper)
World(Calabash::Android::Operations)
World(KrakenMobile::Operations)

AfterConfiguration do
  require 'calabash-android/calabash_steps'
  require 'kraken-mobile/runners/calabash/android/kraken_steps'
end
