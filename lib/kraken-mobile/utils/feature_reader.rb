require 'kraken-mobile/models/feature_file'

module Utils
  module FeatureReader
    # TODO, Read file instead of list of files
    def feature_files
      features_dir = File.join(FileUtils.pwd, K::FEATURES_PATH)
      return [] unless File.directory?(features_dir)

      files = Dir[File.join(features_dir, '**{,/*/**}/*')].uniq
      files.grep(/\.feature$/)
    end
  end
end
