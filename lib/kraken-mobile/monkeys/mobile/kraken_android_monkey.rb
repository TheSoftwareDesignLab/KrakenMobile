module KrakenAndroidMonkey
  def execute_kraken_monkey(number_of_events)
    number_of_events.times do |_i|
      execute_random_action
    end
  end

  def execute_random_action
    Timeout.timeout(K::MONKEY_DEFAULT_TIMEOUT, RuntimeError) do
      begin
        arr = [
          method(:random_click), method(:insert_random_text)
        ]
        arr.sample.call
      rescue StandardError => _e
        puts 'ERROR: Kraken monkey couldn\'t perfom action'
      end
    end
  end

  # Actions
  private

  def random_click
    elements = query('*')
    return if elements.nil?
    return if elements.none?

    element = elements.sample
    return if element['rect'].nil?

    x = element['rect']['x']
    y = element['rect']['y']
    perform_action('touch_coordinate', x, y)
  end

  def insert_random_text
    inputs = query('android.support.v7.widget.AppCompatEditText')
    return if inputs.nil?
    return if inputs.none?

    input = inputs.sample
    return if input['rect'].nil?

    x = input['rect']['x']
    y = input['rect']['y']
    perform_action('touch_coordinate', x, y)
    enter_text SecureRandom.hex
  end

  def input_texts
    query('android.support.v7.widget.AppCompatEditText')
  end
end
