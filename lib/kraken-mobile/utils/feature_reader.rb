require 'kraken-mobile/models/feature_file'

module Utils
  module FeatureReader
    # TODO, Read file instead of list of files
    # TODO, Change features folder
    def feature_files
      features_dir = File.join(FileUtils.pwd, 'features')
      return [] unless File.directory?(features_dir)

      files = Dir[File.join(features_dir, '**{,/*/**}/*')].uniq
      files.grep(/\.feature$/)
    end

    def devices_needed(feature_path)
      parser = Gherkin::Parser.new
      file_content = File.open(file_path).read
      gherkin_document = parser.parse(file_content)
      pickles = Gherkin::Pickles::Compiler.new.compile(gherkin_document)
      pickles.each do |scenario|
        
      end
    end
  end
end
