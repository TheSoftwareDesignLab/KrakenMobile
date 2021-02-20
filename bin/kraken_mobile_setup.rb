require 'io/console'
require 'tty-prompt'
$LOAD_PATH << File.expand_path('../lib', __dir__)
require 'kraken-mobile/utils/k.rb'

class KrakenSetup
  WEB_IDENTIFIER = 'Web'.freeze
  IS_WEB_AVAILABLE_FOR_SELECTION = true

  attr_accessor :prompt
  attr_accessor :devices_connected_id
  attr_accessor :settings

  def initialize
    @prompt = TTY::Prompt.new
    @available_devices_ids = available_devices_ids_for_select
    @settings = {}
  end

  def run
    number_of_devices_required.times do |index|
      user_id = index + 1
      selected_device_id = select_device_for_user_with_id(user_id)
      if selected_device_id == WEB_IDENTIFIER
        handle_web_setup_for_user_with_id(user_id)
      else
        handle_mobile_setup_for_user_with_id(user_id, selected_device_id)
      end
    end
    save_user_settings_to_file
  end

  private

  def handle_web_setup_for_user_with_id(user_id)
    save_web_device_settings_for_user_with_id(user_id: user_id)
  end

  def handle_mobile_setup_for_user_with_id(user_id, device_id)
    selected_apk = select_apk_for_user_with_id(user_id)
    save_mobile_device_settings_for_user_with_id(
      user_id: user_id, apk: selected_apk,
      device_id: device_id
    )
    delete_selected_device_id_from_available_devices(device_id)
  end

  def save_user_settings_to_file
    open('kraken_mobile_settings.json', 'w') do |f|
      f.puts @settings.to_json
    end

    puts 'Saved your settings to .kraken_mobile_settings. You can edit '\
    'the settings manually or run this setup script again'
  end

  def number_of_devices_required
    number_of_devices = -1
    max_devices = max_number_of_devices
    while number_of_devices <= 0 || number_of_devices > max_number_of_devices
      number_of_devices = @prompt.ask(
        'How many devices do you want to use?', convert: :int
      )

      if number_of_devices.zero?
        @prompt.error('Number of devices can\'t be less than 1.')
      end

      if number_of_devices > max_devices
        @prompt.error(
          "You can run Kraken only in #{max_devices} device" \
          "#{max_devices > 1 ? 's' : ''}"
        )
      end
    end
    number_of_devices
  end

  def delete_selected_device_id_from_available_devices(device_id)
    @available_devices_ids.delete(device_id)
  end

  def save_mobile_device_settings_for_user_with_id(
    user_id:, apk:, device_id:
  )
    device = ADB.connected_devices.select { |d| d.id == device_id }.first
    @settings[user_id] = {
      id: device_id,
      model: device.model,
      type: K::ANDROID_DEVICE,
      config: {
        apk_path: apk
      }
    }
  end

  def save_web_device_settings_for_user_with_id(user_id:)
    device = WebDevice.factory_create
    @settings[user_id] = {
      id: device.id,
      model: device.model,
      type: K::WEB_DEVICE,
      config: {}
    }
  end

  def select_apk_for_user_with_id(id)
    valid_apk = false

    until valid_apk
      entered_text = @prompt.ask(
        "What APK user #{id} is going to run?", required: true
      )
      entered_apk_path = File.expand_path(entered_text)
      valid_apk = apk_file?(File.expand_path(entered_apk_path))
      @prompt.error('APK path is not valid.') unless valid_apk
    end
    entered_apk_path
  end

  def select_device_for_user_with_id(id)
    @prompt.select(
      "Choose your user #{id}", @available_devices_ids
    )
  end

  def available_devices_ids_for_select
    devices_connected_id = ADB.connected_devices.map(&:id)
    devices_connected_id << WEB_IDENTIFIER if IS_WEB_AVAILABLE_FOR_SELECTION
    devices_connected_id
  end

  def max_number_of_devices
    return 100 if IS_WEB_AVAILABLE_FOR_SELECTION

    ADB.connected_devices.count
  end
end
