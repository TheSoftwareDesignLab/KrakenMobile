require 'calabash-android/operations'

module KrakenMobile
  module CalabashAndroid
    module Operations
      def install_app_with_calabash
        operations_module = Calabash::Android::Operations
        default_device = operations_module::Device.new(operations_module, ENV["ADB_DEVICE_ARG"], ENV["TEST_SERVER_PORT"], ENV["APP_PATH"], ENV["TEST_APP_PATH"])
        default_device.ensure_apps_installed
      end

      def uninstall_app_with_calabash
        operations_module = Calabash::Android::Operations
        default_device = operations_module::Device.new(operations_module, ENV["ADB_DEVICE_ARG"], ENV["TEST_SERVER_PORT"], ENV["APP_PATH"], ENV["TEST_APP_PATH"])
        default_device.uninstall_app(package_name(default_device.test_server_path))
        default_device.uninstall_app(package_name(default_device.app_path))
      end

      def start_kraken_test_server_in_background scenario
        channel = @scenario_tags.grep(/@user/).first
        start_test_server_in_background
        start_setup(channel, scenario)
      end

      def shutdown_kraken_test_server scenario
        channel = @scenario_tags.grep(/@user/).first
        end_setup channel, scenario
        if scenario.failed?
          screenshot_embed
        end
        shutdown_test_server
      end
    end
  end
end
