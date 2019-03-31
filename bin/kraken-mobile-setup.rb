require "io/console"
require "tty-prompt"

def kraken_setup
  prompt = TTY::Prompt.new
  runner = KrakenMobile::Constants::CALABASH_ANDROID
  device_manager = KrakenMobile::DevicesHelper::Manager.new({runner: runner})
  @settings = []

  devices_connected = device_manager.connected_devices
  devices_connected_id = devices_connected.map { |device| device.id }
  for i in 0...devices_connected.size
    selected_device_id = prompt.select("Choose your user #{i+1}", devices_connected_id)
    valid_apk = false
    entered_apk_path = nil

    while(!valid_apk)
      entered_text = prompt.ask("What APK user #{i+1} is going to run?", required: true)
      entered_apk_path = File.expand_path(entered_text)
      valid_apk = is_apk_file?(File.expand_path(entered_apk_path))
      prompt.error("APK path is not valid.") unless valid_apk
    end

    device = devices_connected.select { |d| d.id == selected_device_id }.first
    @settings[i] = {
      id: device.id,
      model: device.model,
      config: {
        apk_path: entered_apk_path
      }
    }
    devices_connected_id.delete(selected_device_id)
  end
  
  open('kraken_mobile_settings.json', 'w') do |f|
    f.puts @settings.to_json
  end
  puts "Saved your settings to .kraken_mobile_settings. You can edit the settings manually or run this setup script again"
end