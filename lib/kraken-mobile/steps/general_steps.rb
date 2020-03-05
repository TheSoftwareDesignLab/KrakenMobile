ParameterType(
  name: 'property',
  regexp: /[^\"]*/,
  type: String,
  transformer: lambda do |string|
    if string_is_a_property?(string)
      string.slice!('<')
      string.slice!('>')
      handle_property(string)
    elsif string_is_a_faker?(string)
      handle_faker(string)
    else
      return string
    end
  end
)

private

def current_process_id
  tag_process_id = @scenario_tags.grep(/@user/).first
  process_id = tag_process_id.delete_prefix('@user')
  return 'ERROR: User not foud for scenario' if process_id.nil?

  process_id
end

def string_is_a_property?(string)
  string.start_with?('<') &&
    string.end_with?('>')
end

def string_is_a_faker?(string)
  string.start_with?('$') || string.start_with?('$$')
end

def handle_property(property)
  properties = all_user_properties_as_json
  process_id = current_process_id
  user_id = "@user#{process_id}"

  if !properties[user_id] || !properties[user_id][property]
    raise "Property <#{property}> not found for @user#{current_process_id}"
  end

  properties[user_id][property]
end

def all_user_properties_as_json
  raise 'ERROR: No properties file found' if ENV[K::PROPERTIES_PATH].nil?

  properties_absolute_path = File.expand_path(ENV[K::PROPERTIES_PATH])
  raise 'ERROR: Properties file not found' unless File.file?(
    properties_absolute_path
  )

  file = open(properties_absolute_path)
  content = file.read
  JSON.parse(content)
end

def handle_faker(faker)
  nil
end
