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
  end
end
