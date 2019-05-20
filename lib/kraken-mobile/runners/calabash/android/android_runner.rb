require 'kraken-mobile/helpers/devices_helper/manager'
require 'kraken-mobile/helpers/feature_grouper'
require 'kraken-mobile/helpers/reporter'
require 'kraken-mobile/runners/runner'
require 'kraken-mobile/constants'
require 'kraken-mobile/runners/calabash/android/apk_signer.rb'
require 'parallel'
require 'digest'
require 'fileutils'
require 'erb'

module KrakenMobile
	module Runner
		class CalabashAndroidRunner < KrakenRunner
			BASE_COMMAND = "calabash-android run"

      def initialize(options)
        super(options)
        default_runner = KrakenMobile::Constants::CALABASH_ANDROID
				@devices_manager = DevicesHelper::Manager.new({runner: default_runner, config_path: @options[:config_path]})
        @adb_helper = @devices_manager.device_helper
        @execution_id = Digest::SHA256.hexdigest("#{Time.now.to_f}")
        @reporter = KrakenMobile::Reporter.new(@execution_id, options)
			end

      #-------------------------------
      # Hooks
      #-------------------------------
      def before_all
        Dir.mkdir(KrakenMobile::Constants::REPORT_PATH) unless File.exists?(KrakenMobile::Constants::REPORT_PATH)
        Dir.mkdir("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}")
        devices_id_list = []
        @devices_manager.connected_devices.each_with_index do |device, index|
          height, width = @adb_helper.screen_size device.id
          sdk_version = @adb_helper.sdk_version device.id
          devices_id_list << { user: (index+1), id: device.id, model: device.model, screen_height: height, screen_width: width, sdk: sdk_version }
          Dir.mkdir("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}")
        end
        file = open("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{KrakenMobile::Constants::REPORT_DEVICES_FILE_NAME}.json", 'w')
        file.puts(devices_id_list.to_json)
        file.close
        source_dir = File.expand_path("../../../../../../reporter/assets/", __FILE__)
        FileUtils.cp_r(source_dir, "#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/")
      end

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
        before_all
        feature_folder = @options[:feature_folder]
        devices_connected = @devices_manager.connected_devices
        groups = FeatureGrouper.file_groups(feature_folder, devices_connected.size)
        threads = groups.size
        puts "Running with #{threads} threads: #{groups}"
        test_results = Parallel.map_with_index(
          groups,
          :in_threads => threads,
          :start => lambda { |group, index|
            before_execution(index)
          },
          :finish => lambda { |group, index, _|
            after_execution(index)
          }
        ) do |group, index|
          run_tests(group, index, @options)
          @reporter.generate_device_report devices_connected[index]
        end
        @reporter.generate_general_report
      end

      def run_tests(test_files, process_number, options)
				command = build_execution_command(process_number, options[:apk_path], test_files)
				puts "\n****** PROCESS #{process_number} STARTED ******\n\n"
				@command_helper.execute_command(process_number, command)
				puts "\n****** PROCESS #{process_number} COMPLETED ******\n\n"
			end

      #-------------------------------
      # Helpers
      #-------------------------------
			def build_execution_command process_number, general_apk, test_files
        device = @devices_manager.connected_devices[process_number]
        raise "Theres not a device for process #{process_number}" unless device
        apk_path = device.config["apk_path"] ? device.config["apk_path"] : general_apk
        raise "Invalid apk path" unless apk_path
        cucumber_options = "--format pretty --format json -o #{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}/#{KrakenMobile::Constants::REPORT_FILE_NAME}.json"
				execution_command = @command_helper.build_command [BASE_COMMAND, apk_path, cucumber_options, *test_files, "--tags @user#{device.position}"]
				env_variables = {
					AUTOTEST: '1',
					ADB_DEVICE_ARG: device.id,
					DEVICE_INFO: device.model,
					TEST_PROCESS_NUMBER: (process_number+1).to_s,
					SCREENSHOT_PATH: "#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}/#{device.screenshot_prefix}",
          PROTOCOL: @options[:protocol],
          RUNNER: KrakenMobile::Constants::CALABASH_ANDROID
				}
        env_variables[:CONFIG_PATH] = @options[:config_path] if @options[:config_path]
        env_variables[:PROPERTIES_PATH] = @options[:properties_path] if @options[:properties_path]
				exports = @command_helper.build_export_env_command env_variables
				exports + @command_helper.terminal_command_separator + execution_command
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
