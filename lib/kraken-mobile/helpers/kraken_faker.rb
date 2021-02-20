require 'faker'
require 'kraken-mobile/utils/k.rb'
require 'json'

class KrakenFaker
  #-------------------------------
  # Fields
  #-------------------------------
  attr_accessor :process_id

  #-------------------------------
  # Constructors
  #-------------------------------
  def initialize(process_id:)
    raise 'ERROR: Can\'t create faker for null process id' if process_id.nil?

    @process_id = process_id
  end

  #-------------------------------
  # Helpers
  #-------------------------------
  def generate_value_for_key(key:)
    value = if key.start_with?('$name')
              generate_name
            elsif key.start_with?('$number')
              generate_number
            elsif key.start_with?('$email')
              generate_email
            elsif key.start_with?('$string')
              generate_string
            elsif key.start_with?('$date')
              generate_date
            else
              raise 'ERROR: Faker key not supported'
            end
    save_key_value_in_dictionary(key: key, value: value)
    value
  end

  def reuse_value_for_key(key:)
    dictionary = dictionary_json
    key = key.delete_prefix('$')

    raise 'ERROR: Key does not exist' if dictionary[process_id.to_s].nil?
    if dictionary[process_id.to_s][key.to_s].nil?
      raise 'ERROR: Key does not exist'
    end

    dictionary[process_id.to_s][key.to_s]
  end

  def dictionary_json
    create_dictionary_json_file unless dictionary_json_file_exists?

    absolute_dictionary_path = File.expand_path(K::DICTIONARY_PATH)
    file = open(absolute_dictionary_path)
    content = file.read
    file.close
    JSON.parse(content)
  end

  def create_dictionary_json_file
    absolute_dictionary_path = File.expand_path(K::DICTIONARY_PATH)
    File.open(absolute_dictionary_path, 'w') do |f|
      f.puts({}.to_json)
    end
  end

  def dictionary_json_file_exists?
    absolute_dictionary_path = File.expand_path(K::DICTIONARY_PATH)
    File.file?(absolute_dictionary_path)
  end

  def save_key_value_in_dictionary(key:, value:)
    current_json = dictionary_json
    current_json[process_id.to_s] = {} if current_json[process_id.to_s].nil?
    current_json[process_id.to_s][key.to_s] = value

    absolute_dictionary_path = File.expand_path(K::DICTIONARY_PATH)
    open(absolute_dictionary_path, 'w') do |f|
      f.puts(current_json.to_json)
    end
  end

  #-------------------------------
  # Generators
  #-------------------------------
  def generate_name
    Faker::Name.first_name
  end

  def generate_number
    Faker::Number.number(digits: rand(10))
  end

  def generate_email
    Faker::Internet.email
  end

  def generate_string
    Faker::String.random(length: rand(100))
  end

  def generate_date
    Faker::Date.in_date_period.to_s
  end
end
