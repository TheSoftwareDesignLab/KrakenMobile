require 'json'
require 'kraken-mobile/helpers/feature_analyzer'

module KrakenMobile
  class FeatureGrouper
    # Returns files in feature_folder distributed equally in group size.
    def self.distributed_file_groups(feature_folder, group_size)
      files = feature_files_in_folder feature_folder
      groups = create_file_groups group_size,files
      groups
    end

    # All groups contains all files in feature_folder
    def self.file_groups(feature_folder, group_size)
      files = feature_files_in_folder feature_folder
      ensure_features_format files
      group_size.times.map { files }
    end

    def self.create_file_groups group_size, files
      files_per_group = files.size/group_size
      number_of_remaining_files = files.size % group_size
      groups = Array.new(group_size) { []  }
      groups.each do |group|
        files_per_group.times {
          group << files.delete_at(0)
        }
      end
      unless number_of_remaining_files == 0
        groups[0..(number_of_remaining_files-1)].each do |group|
          group << files.delete_at(0)
        end
      end
      groups.reject(&:empty?)
    end

    def self.feature_files_in_folder(feature_dir_or_file)
      if File.directory?(feature_dir_or_file) # Is a folder containing feature files.
        files = Dir[File.join(feature_dir_or_file, "**{,/*/**}/*")].uniq
        files.grep(/\.feature$/)
      elsif feature_dir_or_file.include?('.feature') # Is a feature file.
        [feature_dir_or_file]
      else
        []
      end
    end
  end
end
