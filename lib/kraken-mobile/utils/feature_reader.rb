require 'kraken-mobile/models/feature_file'

module Utils
  module FeatureReader
    def feature_files
      features_dir = File.join(FileUtils.pwd, K::FEATURES_PATH)
      unless File.exist?(features_dir)
        raise "ERROR: File or directory '#{features_dir}' does not exists"
      end
      # Is a file not directory
      return [features_dir] if features_dir.include?('.feature')

      files = Dir[File.join(features_dir, '**{,/*/**}/*')].uniq
      files.grep(/\.feature$/)
    end
  end
end
