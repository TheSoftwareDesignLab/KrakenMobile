module Android
  module Commands
    # List of connected devices/emulators
    def adb_devices_l
      `adb devices -l`
    end

    def file_content(device_id:, file_name:)
      `adb -s #{device_id} shell "cat /sdcard/#{file_name} 2> /dev/null"`
    end

    def write_content_to_file_with_name_in_device(
      content:, device_id:, file_name:
    )
      `adb -s #{device_id} shell "echo "#{content}" > /sdcard/#{file_name}"`
    end

    def create_file_with_name_in_device(device_id:, file_name:)
      `adb -s #{device_id} shell "> /sdcard/#{file_name}"`
    end

    def delete_file_with_name_in_device(device_id:, file_name:)
      `adb -s #{device_id} shell "rm -rf /sdcard/#{file_name}"`
    end
  end
end
