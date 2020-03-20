require 'kraken-mobile/hooks/mobile_operations'

Before do |scenario|
  start_test_kraken_server_in_background
end

After do |scenario|
  shutdown_test_kraken_server
end
