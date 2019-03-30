require "io/console"

def kraken_setup
  @settings = [
    {
      id: "93c6af52",
      model: "ONEPLUS_A6013"
    }
  ]

  open('kraken_mobile_settings.json', 'w') do |f|
    f.puts @settings.to_json
  end
  puts "Saved your settings to .kraken_mobile_settings. You can edit the settings manually or run this setup script again"
end
