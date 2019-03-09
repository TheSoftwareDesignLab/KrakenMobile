require 'fileutils'
require 'find'
require 'parallel'
require 'kraken-mobile/helpers/devices_helper/adb_helper'
require 'kraken-mobile/helpers/feature_grouper'
require 'kraken-mobile/helpers/command_helper'

module KrakenMobile
	module Runner
		class AndroidRunner
			BASE_COMMAND = "calabash-android run"

			def initialize()
				@adb_helper = DevicesHelper::AdbHelper.new()
				@command_helper = CommandHelper.new()
			end

			def run_tests(test_files, process_number, options)
				cucumber_options = "#{options[:cucumber_options]} #{options[:cucumber_reports]}"
				command = build_execution_command(process_number, options[:apk_path], cucumber_options, test_files)
				puts "\n****** PROCESS #{process_number} STARTED ******\n\n"
				@command_helper.execute_command(process_number, command)
				puts "\n****** PROCESS #{process_number} COMPLETED ******\n\n"
			end

			def build_execution_command process_number, apk_path, cucumber_options, test_files
        device = @adb_helper.connected_devices[process_number]
				execution_command = @command_helper.build_command [BASE_COMMAND, apk_path, cucumber_options, *test_files, "--tags @user#{device.position}"]
				env_variables = {
					AUTOTEST: '1',
					ADB_DEVICE_ARG: device.id,
					DEVICE_INFO: device.model,
					TEST_PROCESS_NUMBER: (process_number+1).to_s,
					SCREENSHOT_PATH: device.screenshot_prefix
				}
				exports = @command_helper.build_export_env_command env_variables
				exports + @command_helper.terminal_command_separator + execution_command
			end
		end
	end
end
