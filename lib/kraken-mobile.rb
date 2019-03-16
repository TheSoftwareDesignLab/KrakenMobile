require 'kraken-mobile/helpers/devices_helper/adb_helper'
require 'kraken-mobile/runners/calabash/android_runner'

module KrakenMobile
	class App
		# Constructors
		def initialize(options)
			@options = options
			@runner = Runner::AndroidRunner.new()
			@devices_helper = DevicesHelper::AdbHelper.new()
		end

		# Helpers
		def run_in_parallel
			feature_folder = @options[:feature_folder]
			devices_connected = @devices_helper.connected_devices
			groups = FeatureGrouper.file_groups(feature_folder, devices_connected.size)
			threads = groups.size
			puts "Running with #{threads} threads: #{groups}"
			test_results = Parallel.map_with_index(
				groups,
				:in_threads => threads,
        :start => lambda { |group, index|
          @runner.before_feature(index)
        },
				:finish => lambda { |group, index, _|
          @runner.after_feature(index)
        }
			) do |group, index|
				@runner.run_tests(group, index, @options)
			end
		end
	end
end
