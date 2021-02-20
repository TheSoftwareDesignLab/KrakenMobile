require 'fileutils'

# Abstract class
class DeviceProcess
  attr_accessor :id
  attr_accessor :device
  attr_accessor :test_scenario

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(id:, device:, test_scenario:)
    @id = id
    @device = device
    @test_scenario = test_scenario
  end

  #-------------------------------
  # Required methods
  #-------------------------------
  def before_execute
    raise 'ERROR: before_execute not implemented.'
  end

  def execute
    raise 'ERROR: execute not implemented.'
  end

  def after_execute
    raise 'ERROR: after_execute not implemented.'
  end

  def run
    before_execute
    execute
    after_execute
  end

  #-------------------------------
  # Methods
  #-------------------------------
  def register_process_to_directory
    File.open(K::DIRECTORY_PATH, 'a') do |file|
      file.puts("#{id}#{K::SEPARATOR}#{device}")
    end
  end

  def unregister_process_from_directory
    File.open(K::DIRECTORY_PATH, 'r') do |f|
      File.open("#{K::DIRECTORY_PATH}.tmp", 'w') do |f2|
        f.each_line do |line|
          f2.write(line) unless line.start_with?(
            "#{id}#{K::SEPARATOR}#{device}"
          )
        end
      end
    end
    FileUtils.mv("#{K::DIRECTORY_PATH}.tmp", K::DIRECTORY_PATH)
  end

  def notify_ready_to_start
    File.open(K::DIRECTORY_PATH, 'a') do |file|
      file.puts("#{id}#{K::SEPARATOR}#{device}")
    end
  end

  def running_on_windows?
    RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/
  end

  def exporting_command_for_environment_variables(variables = {})
    commands = variables.map do |key, value|
      if running_on_windows?
        "(SET \"#{key}=#{value}\")"
      else
        "#{key}=#{value};export #{key}"
      end
    end
    commands.join(terminal_command_separator)
  end

  def self.directory
    return [] unless File.exist?(K::DIRECTORY_PATH)

    directory = nil
    File.open(K::DIRECTORY_PATH, 'r') do |file|
      directory = file.each_line.map(&:to_s).map(&:strip)
    end

    directory || []
  end

  def self.registered_process_ids
    directory = DeviceProcess.directory
    directory.map do |entry|
      info = entry.strip.split(K::SEPARATOR)
      info[0]
    end.compact.uniq
  end

  def self.notify_process_state(process_id:, state:)
    raise 'ERROR: Process id can\'t be nil.' if process_id.nil?

    file_path = K::PROCESS_STATE_FILE_PATH[state]
    raise 'ERROR: State does not exist.' if file_path.nil?

    File.open(file_path, 'a') do |file|
      file.puts(process_id)
    end
  end

  def self.processes_in_state(state)
    file_path = K::PROCESS_STATE_FILE_PATH[state]
    return [] if file_path.nil?
    return [] unless File.exist?(file_path)

    devices_ready = nil
    File.open(file_path, 'r') do |file|
      devices_ready = file.each_line.map(&:to_s).map(&:strip)
    end

    devices_ready || []
  end

  def terminal_command_separator
    return ' & ' if running_on_windows?

    ';'
  end
end
