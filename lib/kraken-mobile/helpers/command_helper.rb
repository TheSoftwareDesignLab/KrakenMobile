module KrakenMobile
	class CommandHelper
		def user_is_using_windows
			RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/
		end

		def terminal_command_separator
			user_is_using_windows ? ' & ' : ';'
		end

		def build_command commands
			commands.compact*' '
		end

    # Exports a list of environment variables to the users computer.
		def build_export_env_command env_variables
			commands = env_variables.map { |key, value|
				user_is_using_windows ? "(SET \"#{key}=#{value}\")" : "#{key}=#{value};export #{key}"
			}
			commands.join(terminal_command_separator)
		end

		def execute_command process_number, command
			output = open("|#{command}", 'r') { |output| show_output(output, process_number)  }
			exitstatus = $?.exitstatus
		end

		def show_output(output, process_number)
			loop do
				begin
					line = output.readline()
					$stdout.print "#{process_number}> #{line}"
					$stdout.flush
				end
			end rescue EOFError
		end
	end
end
