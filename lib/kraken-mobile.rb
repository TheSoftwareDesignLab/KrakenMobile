require 'kraken-mobile/runners/calabash/android/android_runner'
require 'kraken-mobile/runners/calabash/monkey/monkey_runner'
require 'kraken-mobile/constants'

module KrakenMobile
	class App
		# Constructors
		def initialize(options)
			@options = options
			@runner = current_runner
		end

		# Helpers
		def run_in_parallel
      @runner.run_in_parallel
		end

    def current_runner
      case @options[:runner]
      when KrakenMobile::Constants::CALABASH_ANDROID
        Runner::CalabashAndroidRunner.new(@options)
      when KrakenMobile::Constants::MONKEY
        Runner::MonkeyRunner.new(@options)
      else
        raise "Invalid Kraken runner."
      end
    end
	end
end
