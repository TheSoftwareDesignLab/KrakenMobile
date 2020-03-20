if ENV["ADB_DEVICE_ARG"].nil?
  require 'kraken-mobile/hooks/web_operations'

  Before do |scenario|
    start_test_kraken_server_in_background(
      scenario: scenario
    )
  end

  After do |scenario|
    shutdown_test_kraken_server(
      scenario: scenario
    )
  end
end
