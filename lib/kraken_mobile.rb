require 'kraken-mobile/utils/feature_reader'
require 'kraken-mobile/test_scenario'
require 'byebug'

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
    @scenarios_queue = []
    build_scenarios_queue
  end

  def start
    execute_next_scenario
  end

  private

  def build_scenarios_queue
    feature_files.each do |feature_path|
      scenarios_queue.unshift(
        TestScenario.new(feature_path)
      )
    end
  end

  def execute_next_scenario
    return if scenarios_queue.count.zero?

    scenario = scenarios_queue.pop
    scenario.execute
    scenario
  end
end
