require "io/console"

def kraken_setup
  @settings = {
    devices: [
      {
        id: "93c6af52",
        model: "ONEPLUS_A6013",
        position: 0
      }
    ]
  }
  open('.kraken_mobile_settings', 'w') do |f|
    f.puts @settings.to_json
  end
  puts "Saved your settings to .kraken_mobile_settings. You can edit the settings manually or run this setup script again"
end
