require 'kraken-mobile/helpers/devices_helper/manager'
require 'kraken-mobile/constants'
require 'calabash-android/operations'
require 'digest'

module KrakenMobile
  module Protocol
    module FileProtocol
      def readSignal(channel, content, timeout)
        devices_helper = DevicesHelper::Manager.new(ENV["RUNNER"]).device_helper
        device_id = channel_to_device_id(channel)
        Timeout::timeout(timeout, RuntimeError) do
          sleep(1) until devices_helper.read_file_content(KrakenMobile::Constants::DEVICE_INBOX_NAME, device_id) == content
        end
      end

      def writeSignal(channel, content)
        devices_helper = DevicesHelper::Manager.new(ENV["RUNNER"]).device_helper
        device_id = channel_to_device_id(channel)
        devices_helper.write_content_to_file(content, KrakenMobile::Constants::DEVICE_INBOX_NAME, device_id)
      end

      def start_setup channel, scenario
        devices_helper = DevicesHelper::Manager.new(ENV["RUNNER"]).device_helper
        device_id = channel_to_device_id(channel)
        scenario_id = build_scenario_id(scenario)
        devices_helper.write_content_to_file "ready_#{scenario_id}", KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device_id
        sleep(1) until devices_helper.connected_devices.all? { |device| devices_helper.read_file_content(KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device.id) == "ready_#{scenario_id}" }
      end

      def end_setup channel, scenario
        devices_helper = DevicesHelper::Manager.new(ENV["RUNNER"]).device_helper
        device_id = channel_to_device_id(channel)
        scenario_id = build_scenario_id(scenario)
        devices_helper.write_content_to_file "end_#{scenario_id}", KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device_id
        sleep(1) until devices_helper.connected_devices.all? { |device| devices_helper.read_file_content(KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device.id) == "end_#{scenario_id}" }
      end

      def install_app_with_calabash
        operations_module = Calabash::Android::Operations
        default_device = operations_module::Device.new(operations_module, ENV["ADB_DEVICE_ARG"], ENV["TEST_SERVER_PORT"], ENV["APP_PATH"], ENV["TEST_APP_PATH"])
        default_device.ensure_apps_installed
        #default_device.clear_app_data TODO Opcional para el usuario
      end

      def uninstall_app_with_calabash
        operations_module = Calabash::Android::Operations
        default_device = operations_module::Device.new(operations_module, ENV["ADB_DEVICE_ARG"], ENV["TEST_SERVER_PORT"], ENV["APP_PATH"], ENV["TEST_APP_PATH"])
        default_device.uninstall_app(package_name(default_device.test_server_path))
        default_device.uninstall_app(package_name(default_device.app_path))
      end

      # helpers
      def channel_to_device_id channel
        begin
          formatted_channel = channel.tr("@user", "")
          device_position = formatted_channel.to_i - 1
          devices_helper = DevicesHelper::Manager.new(ENV["RUNNER"]).device_helper
          devices_helper.connected_devices[device_position].id
        rescue
          nil
        end
      end

      def build_scenario_id scenario
        location = scenario.location.to_s
        index_of_line_number_start = location.index(":")
        real_location = location[0..index_of_line_number_start-1]
        Digest::SHA256.hexdigest(real_location)
      end
    end
  end
end
