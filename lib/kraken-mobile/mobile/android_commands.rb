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

    def device_orientation(device_id:)
      `adb -s #{device_id} shell dumpsys input | grep 'SurfaceOrientation' \
      | awk '{ print $2 }'`
    end

    def screen_size_for_device_with_id(device_id:)
      `adb -s #{device_id} shell wm size`
    end

    def save_snapshot_for_device_with_id_in_path(device_id:, file_path:)
      `adb -s #{device_id} shell cat /sdcard/window_dump.xml > #{file_path}`
    end

    def sdk_version_for_device_with_id(device_id:)
      `adb -s #{device_id} shell getprop ro.build.version.sdk`
    end
  end
end
