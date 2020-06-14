require 'selenium-webdriver'
require 'faker'

class WebMonkey
  attr_accessor :driver
  attr_accessor :wait
  DEFAULT_WAIT_TIMEOUT = 0.5

  def initialize(driver:)
    self.driver = driver
    self.wait = Selenium::WebDriver::Wait.new(timeout: DEFAULT_WAIT_TIMEOUT)
  end

  # Helpers
  def execute_kraken_monkey(number_of_events)
    number_of_events.times do |_i|
      execute_random_action
    end
  end

  def execute_random_action
    arr = [
      method(:random_click), method(:insert_random_text)
    ]
    arr.sample.call
  rescue StandardError => _e
    nil
  end

  def random_click
    element = @wait.until { driver.find_elements(:xpath, '//*').sample }
    highlight_element(element)
    element.click
    remove_element_highlight(element)
  end

  def insert_random_text
    element = @wait.until { driver.find_elements(:xpath, '//input').sample }
    highlight_element(element)
    element.click
    text = [Faker::Lorem.word, Faker::Lorem.sentence].sample
    element.send_keys(text)
    remove_element_highlight(element)
  end

  private

  def highlight_element(element)
    @driver.execute_script(
      "arguments[0].setAttribute('style', arguments[1]);",
      element,
      'color: red; border: 2px solid red'
    )
  end

  def remove_element_highlight(element)
    @driver.execute_script(
      "arguments[0].setAttribute('style', arguments[1]);",
      element,
      ''
    )
  end
end
