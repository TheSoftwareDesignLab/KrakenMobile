require 'calabash-android/cucumber'
require 'calabash-android/operations'
require 'kraken-mobile/operations'

World(Calabash::Android::ColorHelper)
World(Calabash::Android::Operations)
World(KrakenMobile::Operations)

AfterConfiguration do
  require 'calabash-android/calabash_steps'
  require 'kraken-mobile/kraken_steps'
end
