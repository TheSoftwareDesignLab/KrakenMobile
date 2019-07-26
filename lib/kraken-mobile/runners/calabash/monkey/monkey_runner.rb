require 'kraken-mobile/helpers/devices_helper/manager'
require 'kraken-mobile/helpers/feature_grouper'
require 'kraken-mobile/runners/runner'
require 'kraken-mobile/constants'
require 'kraken-mobile/runners/calabash/android/apk_signer.rb'
require 'kraken-mobile/runners/calabash/android/operations'
require 'kraken-mobile/runners/calabash/android/monkey_helper'
require 'kraken-mobile/protocols/file_protocol'
require 'parallel'
require 'digest'
require 'fileutils'

module KrakenMobile
	module Runner
		class MonkeyRunner < KrakenRunner
      include CalabashAndroid::Operations
      include Calabash::Android::Operations
      include CalabashAndroid::MonkeyHelper
      include Protocol::FileProtocol

      def initialize(options)
        super(options)
        default_runner = KrakenMobile::Constants::MONKEY
				@devices_manager = DevicesHelper::Manager.new({runner: default_runner, config_path: @options[:config_path]})
        @adb_helper = @devices_manager.device_helper
        @execution_id = Digest::SHA256.hexdigest("#{Time.now.to_f}")
			end

      #-------------------------------
      # Hooks
      #-------------------------------
      def before_execution process_number
        device = @devices_manager.connected_devices[process_number]
        raise "There is no device for process #{process_number}" unless device
        @adb_helper.create_file KrakenMobile::Constants::DEVICE_INBOX_NAME, device.id
        @adb_helper.create_file KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device.id
      end

      def after_execution process_number
        device = @devices_manager.connected_devices[process_number]
        raise "There is no device for process #{process_number}" unless device
        @adb_helper.delete_file KrakenMobile::Constants::DEVICE_INBOX_NAME, device.id
        @adb_helper.delete_file KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device.id
      end

      #-------------------------------
      # Execution
      #-------------------------------
      def run_in_parallel
        ensure_apks_signed
        devices_connected = @devices_manager.connected_devices
        threads = devices_connected.count
        puts "Running with #{threads} threads"
        test_results = Parallel.map_with_index(
          devices_connected,
          :in_threads => threads,
          :start => lambda { |device, index|
            before_execution(index)
          },
          :finish => lambda { |device, index, _|
            after_execution(index)
          }
        ) do |device, index|
          run_tests(index, @options)
        end
      end

      def run_tests(process_number, options)
				set_environment_variables(process_number, options[:apk_path])
				puts "\n****** PROCESS #{process_number} STARTED ******\n\n"
        operations_module = Calabash::Android::Operations
        default_device = operations_module::Device.new(operations_module, ENV["ADB_DEVICE_ARG"], ENV["TEST_SERVER_PORT"], ENV["APP_PATH"], ENV["TEST_APP_PATH"])
        install_app_with_calabash
        default_device.start_test_server_in_background
        run_kraken_monkey "#@user#{process_number}", 20
        default_device.shutdown_test_server
        uninstall_app_with_calabash
				puts "\n****** PROCESS #{process_number} COMPLETED ******\n\n"
			end

      #-------------------------------
      # Helpers
      #-------------------------------
			def set_environment_variables process_number, general_apk
        device = @devices_manager.connected_devices[process_number]
        raise "Theres not a device for process #{process_number}" unless device
        apk_path = device.config["apk_path"] ? device.config["apk_path"] : general_apk
        raise "Invalid apk path" unless apk_path
        ENV["APP_PATH"] = apk_path
        ENV["TEST_APP_PATH"] = test_server_path(apk_path)
        ENV["AUTOTEST"] = '1'
        ENV["ADB_DEVICE_ARG"] = device.id
        ENV["DEVICE_INFO"] = device.model
        ENV["TEST_PROCESS_NUMBER"] = (process_number+1).to_s
        ENV["SCREENSHOT_PATH"] = "#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}/#{device.screenshot_prefix}"
        ENV["PROTOCOL"] = KrakenMobile::Constants::FILE_PROTOCOL
        ENV["RUNNER"] = KrakenMobile::Constants::MONKEY
        ENV["CONFIG_PATH"] = @options[:config_path] if @options[:config_path]
			end

      def ensure_apks_signed
        checked_apks = {}
        @devices_manager.connected_devices.each do |device|
          apk_path = device.config["apk_path"] ? device.config["apk_path"] : @options[:apk_path]
          next if checked_apks[apk_path] # Dont check already checked apks
          raise "APK is not signed, you can resign the app by running kraken-mobile resign #{apk_path}" if !KrakenMobile::CalabashAndroid::ApkSigner.is_apk_signed? apk_path
          checked_apks[apk_path] = apk_path
        end
      end

		end
	end
end
