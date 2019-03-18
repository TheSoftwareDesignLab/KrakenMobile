require 'fileutils'
require 'find'
require 'kraken-mobile/helpers/command_helper'

module KrakenMobile
	module Runner
    class KrakenRunner
      def initialize(options)
        @options = options
				@command_helper = CommandHelper.new()
			end

      def run_in_parallel
        raise NotImplementedError.new
      end
    end
	end
end
