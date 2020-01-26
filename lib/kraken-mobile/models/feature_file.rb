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
  def number_of_required_devices
    all_tags = @scenarios.map(&:tags).flatten.uniq
    all_tags.select { |tag| tag.start_with?('@user') }.count
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
