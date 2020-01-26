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
end
