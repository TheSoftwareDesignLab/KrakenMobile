require 'kraken-mobile/helpers/devices_helper/adb_helper.rb' # TODO, Remove this
require 'kraken-mobile/mobile_process.rb'

class TestScenario
  #-------------------------------
  # Fields
  #-------------------------------

  attr_accessor :feature_file_path

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(feature_file_path)
    @feature_file_path = feature_file_path
  end

  #-------------------------------
  # Methods
  #-------------------------------
  def execute
    adb = KrakenMobile::DevicesHelper::AdbHelper.new
    adb.connected_devices.each do |_device|
      MobileProcess.new
    end
  end
end
