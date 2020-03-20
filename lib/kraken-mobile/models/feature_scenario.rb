class FeatureScenario
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :name
  attr_accessor :tags

  #-------------------------------
  # Constructos
  #-------------------------------
  def initialize(name:, tags:)
    @name = name
    @tags = format_tags(tags) || []
  end

  private

  #-------------------------------
  # Helpers
  #-------------------------------
  def format_tags(tags)
    tags.map { |tag| tag[:name] }
  end
end
