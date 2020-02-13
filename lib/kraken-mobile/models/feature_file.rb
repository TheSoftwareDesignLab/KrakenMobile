require 'gherkin/parser'
require 'gherkin/pickles/compiler'
require 'kraken-mobile/models/feature_scenario'

class FeatureFile
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :file_path
  attr_accessor :scenarios

  #-------------------------------
  # Constructos
  #-------------------------------
  def initialize(file_path:)
    @file_path = file_path
    @scenarios = []

    read_content
  end

  #-------------------------------
  # Helpers
  #-------------------------------
  def number_of_required_mobile_devices
    all_tags = @scenarios.map(&:tags).flatten.uniq
    all_tags.select { |tag| tag == '@mobile' }.count
  end

  def number_of_required_web_devices
    all_tags = @scenarios.map(&:tags).flatten.uniq
    all_tags.select { |tag| tag == '@web' }.count
  end

  def number_of_required_devices
    all_tags = @scenarios.map(&:tags).flatten.uniq
    all_tags.select { |tag| tag.start_with?('@user') }.count
  end

  def tags_for_user_id(user_id)
    user_tag = "@user#{user_id}"
    user_scenario = @scenarios.select do |scenario|
      scenario.tags.include?(user_tag)
    end.first
    return [] if user_scenario.nil? || user_scenario.tags.nil?

    user_scenario.tags.reject { |tag| tag == user_tag }
  end

  private

  def read_content
    parser = Gherkin::Parser.new
    file_content = File.open(file_path).read
    gherkin_document = parser.parse(file_content)
    pickles = Gherkin::Pickles::Compiler.new.compile(gherkin_document)
    pickles.each do |scenario|
      scenarios << FeatureScenario.new(
        name: scenario[:name],
        tags: scenario[:tags]
      )
    end
  end
end
