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

  def self.processes_ready
    return [] unless File.exist?(K::DEVICES_READY_PATH)

    devices_ready = nil
    File.open(K::DEVICES_READY_PATH, 'r') do |file|
      devices_ready = file.each_line.map(&:to_s).map(&:strip)
    end

    devices_ready || []
  end

  def self.notify_ready_to_start(process_id)
    raise 'ERROR: Process id can\'t be nil.' if process_id.nil?

    File.open(K::DEVICES_READY_PATH, 'a') do |file|
      file.puts(process_id)
    end
  end
end
