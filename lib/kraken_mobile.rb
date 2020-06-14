require 'kraken-mobile/utils/feature_reader'
require 'kraken-mobile/test_scenario'

class KrakenApp
  include Utils::FeatureReader

  #-------------------------------
  # Fields
  #-------------------------------

  attr_accessor :apk_path
  attr_accessor :scenarios_queue

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(apk_path:, properties_path: nil, config_path: nil)
    @apk_path = apk_path
    @scenarios_queue = []
    save_path_in_environment_variable_with_name(
      name: K::PROPERTIES_PATH, path: properties_path
    )
    save_path_in_environment_variable_with_name(
      name: K::CONFIG_PATH, path: config_path
    )

    build_scenarios_queue
  end

  #-------------------------------
  # Observers
  #-------------------------------
  def on_test_scenario_finished
    execute_next_scenario
  end

  #-------------------------------
  # Helpers
  #-------------------------------

  def start
    execute_next_scenario
  end

  def save_path_in_environment_variable_with_name(name:, path:)
    return if path.nil?

    absolute_path = File.expand_path(path)
    save_value_in_environment_variable_with_name(
      name: name,
      value: absolute_path
    )
  end

  def save_value_in_environment_variable_with_name(name:, value:)
    return if name.nil? || value.nil?

    ENV[name] = value
  end

  private

  def build_scenarios_queue
    feature_files.each do |feature_path|
      scenarios_queue.unshift(
        TestScenario.new(
          kraken_app: self,
          feature_file_path: feature_path
        )
      )
    end
  end

  def execute_next_scenario
    return if scenarios_queue.count.zero?

    scenario = scenarios_queue.pop
    scenario.run
    scenario
  end
end
