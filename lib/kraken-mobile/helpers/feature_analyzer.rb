require 'gherkin/parser'
require 'gherkin/pickles/compiler'

def ensure_features_format files
  files.each do |file_path|
    ensure_feature_has_unique_tags file_path
  end
end

def ensure_feature_has_unique_tags file_path
  parser = Gherkin::Parser.new
  file = open(file_path)
  content = file.read
  gherkin_document = parser.parse(content)
  pickles = Gherkin::Pickles::Compiler.new.compile(gherkin_document)
  tag_hash = {}
  pickles.each do |scenario|
    raise "Scenario '#{scenario[:name]}' can't have more than one @user{int} tag." if scenario[:tags].select{ |tag| tag[:name].start_with? "@user" }.count > 1
    scenario[:tags].each do |tag|
      tag_name = tag[:name]
      if tag_hash[tag_name]
        raise "Tag #{tag_name} is duplicated. Each feature can only have one @user{:int} tag assigned to a scenario."
      else
        tag_hash[tag_name] = tag_name
      end
    end
  end
end
