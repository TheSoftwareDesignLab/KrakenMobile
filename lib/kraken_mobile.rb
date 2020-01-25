require 'kraken-mobile/feature_reader'
require 'kraken-mobile/test_scenario'

class KrakenApp
  include Utils::FeatureReader

  #-------------------------------
  # Fields
  #-------------------------------

  attr_accessor :scenarios_queue

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize
    @scenarios_queue = Queue.new
    build_scenarios_queue
  end

  def start
    execute_next_scenario
  end

  private

  def build_scenarios_queue
    feature_files.each do |feature_path|
      scenarios_queue << TestScenario.new(feature_path)
    end
  end

  def execute_next_scenario
    scenario = scenarios_queue.pop
    scenario.execute
    scenario
  end
end
