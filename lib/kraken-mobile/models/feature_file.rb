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
  def user_tags
    all_tags = @scenarios.map(&:tags).flatten.uniq
    all_tags.select { |tag| tag.start_with?('@user') }
  end

  def system_tags
    @scenarios.map do |scenario|
      tags = scenario.tags
      system_tag = tags.select do |tag|
        tag.start_with?('@web') || tag.start_with?('@mobile')
      end.first
      system_tag || '@mobile'
    end
  end

  def number_of_required_mobile_devices
    system_tags.select { |tag| tag == '@mobile' }.count
  end

  def number_of_required_web_devices
    system_tags.select { |tag| tag == '@web' }.count
  end

  def number_of_required_devices
    user_tags.count
  end

  def required_devices
    users = user_tags
    systems = system_tags

    users.map do |user|
      {
        user_id: user.delete_prefix('@user'),
        system_type: systems.shift || '@mobile'
      }
    end
  end

  def sorted_required_devices
    required_devices.sort_by do |device|
      device[:user_id].to_i
    end
  end

  def tags_for_user_id(user_id)
    user_tag = "@user#{user_id}"
    user_scenario = @scenarios.select do |scenario|
      scenario.tags.include?(user_tag)
    end.first
    return [] if user_scenario.nil? || user_scenario.tags.nil?

    user_scenario.tags.reject { |tag| tag == user_tag }
  end

  def right_syntax?
    all_scenarios_have_a_user_tag? &&
      only_one_user_tag_for_each_scenario? &&
      !duplicate_tags_for_a_user?
  end

  def duplicate_tags_for_a_user?
    taken_user_tags = {}
    scenarios.each do |scenario|
      user_tag = scenario.tags.select do |tag|
        tag.start_with?('@user')
      end.first
      return true unless taken_user_tags[user_tag].nil?

      taken_user_tags[user_tag] = user_tag
    end
    false
  end

  def only_one_user_tag_for_each_scenario?
    scenarios.each do |scenario|
      user_tags = scenario.tags.select do |tag|
        tag.start_with?('@user')
      end
      return false if user_tags.count != 1
    end
    true
  end

  def all_scenarios_have_a_user_tag?
    scenarios.each do |scenario|
      user_tag = scenario.tags.select do |tag|
        tag.start_with?('@user')
      end.first
      return false if user_tag.nil?
    end
    true
  end

  private

  def read_content
    parser = Gherkin::Parser.new
    file = File.open(file_path)
    file_content = file.read
    file.close
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
