require 'kraken-mobile/runners/calabash/android/operations'

Before do |scenario|
  start_kraken_test_server_in_background scenario
end

After do |scenario|
  shutdown_kraken_test_server scenario
  uninstall_app_with_calabash
end
