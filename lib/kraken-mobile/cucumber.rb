require 'calabash-android/cucumber'
require 'calabash-android/operations'
require 'kraken-mobile/operations'
require 'kraken-mobile/kraken_hooks'

World(Calabash::Android::ColorHelper)
World(Calabash::Android::Operations)
World(KrakenMobile::Operations)

AfterConfiguration do
  require 'calabash-android/calabash_steps'
  require 'kraken-mobile/kraken_steps'
end
