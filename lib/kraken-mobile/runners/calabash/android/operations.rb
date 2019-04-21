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
        shutdown_test_server
      end

      # helpers
      def channel_to_device_id channel
        begin
          formatted_channel = channel.tr("@user", "")
          device_position = formatted_channel.to_i - 1
          devices_manager = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]})
          devices_manager.connected_devices[device_position].id
        rescue
          nil
        end
      end
    end
  end
end
