require 'kraken-mobile/runners/calabash/android/android_runner'

module KrakenMobile
	class App
		# Constructors
		def initialize(options)
			@options = options
			@runner = Runner::AndroidRunner.new(options)
		end

		# Helpers
		def run_in_parallel
      @runner.run_in_parallel
		end
	end
end
