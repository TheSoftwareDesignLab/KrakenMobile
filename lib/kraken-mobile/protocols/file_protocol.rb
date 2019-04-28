require 'kraken-mobile/helpers/devices_helper/manager'
require 'kraken-mobile/constants'
require 'calabash-android/operations'
require 'digest'

module KrakenMobile
  module Protocol
    module FileProtocol
      def readSignal(channel, content, timeout)
        devices_helper = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]}).device_helper
        device_id = channel_to_device_id(channel)
        Timeout::timeout(timeout, RuntimeError) do
          sleep(1) until devices_helper.read_file_content(KrakenMobile::Constants::DEVICE_INBOX_NAME, device_id) == content
        end
      end

      def readLastSignal(channel)
        devices_helper = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]}).device_helper
        device_id = channel_to_device_id(channel)
        devices_helper.read_file_content(KrakenMobile::Constants::DEVICE_INBOX_NAME, device_id)
      end

      def readAnySignal(channel, timeout)
        devices_helper = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]}).device_helper
        device_id = channel_to_device_id(channel)
        Timeout::timeout(timeout, RuntimeError) do
          sleep(1) until devices_helper.read_file_content(KrakenMobile::Constants::DEVICE_INBOX_NAME, device_id) != ""
        end
      end

      def readSignalWithKeyworkd(channel, keyword, timeout)
        devices_helper = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]}).device_helper
        device_id = channel_to_device_id(channel)
        Timeout::timeout(timeout, RuntimeError) do
          sleep(1) until devices_helper.read_file_content(KrakenMobile::Constants::DEVICE_INBOX_NAME, device_id).include?(keyword)
          return devices_helper.read_file_content(KrakenMobile::Constants::DEVICE_INBOX_NAME, device_id)
        end
      end

      def writeSignal(channel, content)
        devices_helper = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]}).device_helper
        device_id = channel_to_device_id(channel)
        devices_helper.write_content_to_file(content, KrakenMobile::Constants::DEVICE_INBOX_NAME, device_id)
      end

      def writeSignalToAll(content)
        devices_manager = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]})
        devices_manager.connected_devices.each do |device|
          devices_manager.device_helper.write_content_to_file(content, KrakenMobile::Constants::DEVICE_INBOX_NAME, device.id)
        end
      end

      def writeSignalToAnyDevice(content)
        devices_manager = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]})
        device = devices_manager.connected_devices.sample
        devices_manager.device_helper.write_content_to_file(content, KrakenMobile::Constants::DEVICE_INBOX_NAME, device.id)
        device
      end

      def start_setup channel, scenario
        devices_manager = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]})
        device_id = channel_to_device_id(channel)
        scenario_id = build_scenario_id(scenario)
        devices_manager.device_helper.write_content_to_file "ready_#{scenario_id}", KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device_id
        ordered_tags = ordered_feature_tags scenario
        while true
          compare_criteria = devices_manager.connected_devices.count >= ordered_tags.count ? ordered_tags.count : devices_manager.connected_devices.count
          break if devices_ready_start(devices_manager, scenario_id).count >= compare_criteria
          sleep(1)
        end
      end

      def end_setup channel, scenario
        devices_manager = DevicesHelper::Manager.new({runner: ENV["RUNNER"], config_path: ENV["CONFIG_PATH"]})
        device_id = channel_to_device_id(channel)
        scenario_id = build_scenario_id(scenario)
        devices_manager.device_helper.write_content_to_file "end_#{scenario_id}", KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device_id
        ordered_tags = ordered_feature_tags scenario
        while true
          compare_criteria = devices_manager.connected_devices.count >= ordered_tags.count ? ordered_tags.count : devices_manager.connected_devices.count
          break if devices_ready_to_finish(devices_manager, scenario_id).count >= compare_criteria
          sleep(1)
        end
      end

      # helpers
      def build_scenario_id scenario
        location = scenario.location.to_s
        index_of_line_number_start = location.index(":")
        real_location = location[0..index_of_line_number_start-1]
        Digest::SHA256.hexdigest(real_location)
      end

      def feature_tags scenario
        tag_objects = scenario.feature.children.map { |e| e.tags if e.tags  }.compact
        tags = []
        tag_objects.each do |tag_object|
          names = tag_object.map { |tag| tag.name if tag.name }
          tags.concat names
        end
        tags.uniq.select{ |tag| tag.start_with? "@user" }.sort
      end

      def ordered_feature_tags scenario
        tags = feature_tags scenario
        ordered_tags = []
        tags.count.times do |index|
          if tags[index].include? "@user#{index+1}"
            ordered_tags << tags[index]
          else
            break
          end
        end
        ordered_tags
      end

      def devices_ready_start devices_manager, scenario_id
        devices_manager.connected_devices.select { |device| devices_manager.device_helper.read_file_content(KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device.id) == "ready_#{scenario_id}" }
      end

      def devices_ready_to_finish devices_manager, scenario_id
        devices_manager.connected_devices.select { |device| devices_manager.device_helper.read_file_content(KrakenMobile::Constants::KRAKEN_CONFIGURATION_FILE_NAME, device.id) == "end_#{scenario_id}" }
      end
    end
  end
end
