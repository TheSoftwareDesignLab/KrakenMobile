module Android
  module Commands
    def adb_devices_l
      `adb devices -l`
    end
  end
end
