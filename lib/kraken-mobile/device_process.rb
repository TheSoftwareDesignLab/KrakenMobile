# Abstract class
class DeviceProcess
  attr_accessor :test_scenario  

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize
    raise 'ERROR: Can\'t instantiate this abstract class'
  end
end