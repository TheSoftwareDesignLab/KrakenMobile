require 'kraken-mobile/constants'
require 'digest'
require 'json'

module KrakenMobile
	class Reporter

    PASSED = 'passed'
    FAILED = 'failed',
    SKIPPED = 'skipped',
    PENDING = 'pending',
    NOT_DEFINED = 'undefined',
    AMBIGUOUS = 'ambiguous'

    def initialize(execution_id, options)
      @execution_id = execution_id
      @options = options
    end

    #-------------------------------
    # Generator
    #-------------------------------
    def generate_general_report
      erb_file = File.join(File.expand_path("../../../../reporter/", __FILE__), "index.html.erb")
      html_file = File.join(File.expand_path("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/"), "index.html")
      # Variables
      @devices = [{"user":1,"id":"93c6af52","model":"ONEPLUS_A6013"},{"user":2,"id":"emulator-5554","model":"Android_SDK_built_for_x86"}]
      devices_report = report_by_devices(@devices)
      @features_report = fetures_from_report_by_devices devices_report
      @branches = branches(@features_report).to_json # TODO
      template = File.read(erb_file)
      result = ERB.new(template).result(binding)
      # write result to file
      File.open(html_file, 'w+') do |f|
        f.write result
      end
    end

    def generate_device_report device
      @apk_path = device.config["apk_path"] ? device.config["apk_path"] : @options[:apk_path]
      report_file = open("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}/#{KrakenMobile::Constants::REPORT_FILE_NAME}.json")
      content = report_file.read
      @features = JSON.parse(content)
      @total_scenarios = total_scenarios @features
      @device = device
      @total_failed_scenarios_percentage = total_failed_scenarios_percentage @features
      @total_passed_scenarios_percentage = total_passed_scenarios_percentage @features
      @total_passed_features_percentage = total_passed_features_percentage @features
      @total_failed_features_percentage = total_failed_features_percentage @features
      erb_file = File.join(File.expand_path("../../../../reporter/", __FILE__), "feature_report.html.erb")
      html_file = File.join(File.expand_path("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}/"), File.basename(erb_file, '.erb')) #=>"page.html"
      # Variables
      template = File.read(erb_file)
      result = ERB.new(template).result(binding)
      # write result to file
      File.open(html_file, 'w+') do |f|
        f.write result
      end
      generate_features_report @features, device
    end

    def report_by_devices devices
      devices_report = {}
      devices.each do |device|
        next if !File.exists?("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device[:id]}/#{KrakenMobile::Constants::REPORT_FILE_NAME}.json")
        report_file = open("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device[:id]}/#{KrakenMobile::Constants::REPORT_FILE_NAME}.json")
        content = report_file.read
        devices_report[device[:user]] = JSON.parse(content)
        devices_report[device[:user]].each do |d| d["device_id"] = device[:id] if !d["device_id"] end
      end
      devices_report
    end

    def fetures_from_report_by_devices report_by_devices
      features = {}
      report_by_devices.keys.each do |user_key|
        report = report_by_devices[user_key]
        report.each do |feature|
          features[feature["id"]] = {} if !features[feature["id"]]
          features[feature["id"]]["name"] = feature["name"] if !features[feature["id"]]["name"] && feature["name"]
          features[feature["id"]]["uri"] = feature["uri"] if !features[feature["id"]]["uri"] && feature["uri"]
          features[feature["id"]]["hash"] = feature_id(feature) if !features[feature["id"]]["hash"]
          features[feature["id"]]["devices"] = {} if !features[feature["id"]]["devices"]
          features[feature["id"]]["devices"][user_key] = feature["elements"] if feature["elements"]
        end
      end
      features
    end

    def generate_features_report features, device
      features.each do |feature|
        generate_feature_report feature, device
      end
    end

    def generate_feature_report feature, device
      Dir.mkdir("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}/features_report") unless File.exists?("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}/features_report")
      file_name = feature_id feature
      erb_file = File.join(File.expand_path("../../../../reporter/", __FILE__), "scenario_report.html.erb")
      html_file = File.join(File.expand_path("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device.id}/features_report"), "#{file_name}.html") #=>"page.html"
      # Variables
      @feature = feature
      template = File.read(erb_file)
      result = ERB.new(template).result(binding)
      # write result to file
      File.open(html_file, 'w+') do |f|
        f.write result
      end
    end

    # 0: create 1: commit 2: merge
    def branches features_report
      branches = {}
      features_report.keys.each do |key|
        report = features_report[key]
        branches[report["hash"]] = {} if !branches[report["hash"]]
        branches[report["hash"]]["steps"]= [] if !branches[report["hash"]]["steps"]
        devices = report["devices"]
        devices.keys.each do |device_key|
          branches[report["hash"]]["steps"] << { type: 0, name: device_key }
          feature_steps = devices[device_key][0]["steps"] if devices[device_key].count > 0 && devices[device_key][0]["steps"]
          feature_steps.each do |step|
            hash_step = { type: 1, name: device_key}
            hash_step[:image] = step["after"][0]["embeddings"][0] if step["after"].count > 0 && step["after"][0]["embeddings"] && step["after"][0]["embeddings"].count > 0
            branches[report["hash"]]["steps"] << hash_step
          end
        end
      end
      branches
    end

    #-------------------------------
    # Helpers
    #-------------------------------
    def total_scenarios features
      how_many = 0
      features.each do |feature|
        scenarios = feature["elements"]
        how_many += scenarios.count if scenarios
      end
      how_many
    end

    def feature_id feature
      Digest::SHA256.hexdigest("#{feature["id"].strip}#{feature["uri"].strip}")
    end

    def passed_features features
      features.select{ |feature| passed_scenarios(feature) == feature["elements"].count }
    end

    def failed_features features
      features.select{ |feature| failed_scenarios(feature) == feature["elements"].count }
    end

    def feature_duration feature
      scenarios = feature["elements"]
      how_long = 0
      scenarios.each do |scenario|
        how_long += scenario_duration(scenario)
      end
      how_long
    end

    def scenario_duration scenario
      how_long = 0
      scenario["steps"].each do |step|
        how_long += step["result"]["duration"] if step["result"]
      end
      how_long
    end

    def passed_scenarios feature
        scenarios = feature["elements"]
        scenarios.select{ |scenario|
          steps = scenario["steps"]
          steps.all?{ |step| step["result"] && step["result"]["status"] == PASSED }
        }
    end

    def failed_scenarios feature
      scenarios = feature["elements"]
      scenarios.select{ |scenario|
        steps = scenario["steps"]
        steps.any?{ |step| step["result"] && step["result"]["status"] != PASSED }
      }
    end

    def total_passed_scenarios features
      how_many = 0
      features.each do |feature|
        how_many += passed_scenarios(feature).count
      end
      how_many
    end

    def total_failed_scenarios features
      how_many = 0
      features.each do |feature|
        how_many += failed_scenarios(feature).count
      end
      how_many
    end

    def total_passed_features features
      how_many = 0
      features.each do |feature|
        how_many += 1 if feature_passed?(feature)
      end
      how_many
    end

    def total_failed_features features
      how_many = 0
      features.each do |feature|
        how_many += 1 if !feature_passed?(feature)
      end
      how_many
    end

    def feature_passed_scenarios_percentage feature
      (passed_scenarios(feature).count.to_f/feature["elements"].count.to_f).round(2) * 100.00
    end

    def feature_failed_scenarios_percentage feature
      (failed_scenarios(feature).count.to_f/feature["elements"].count.to_f).round(2) * 100.00
    end

    def total_passed_scenarios_percentage features
      (total_passed_scenarios(features).to_f/total_scenarios(features).to_f).round(2) * 100.00
    end

    def total_passed_features_percentage features
      (total_passed_features(features).to_f/features.count.to_f).round(2) * 100.00
    end

    def total_failed_scenarios_percentage features
      (total_failed_scenarios(features).to_f/total_scenarios(features).to_f).round(2) * 100.00
    end

    def total_failed_features_percentage features
      (total_failed_features(features).to_f/features.count.to_f).round(2) * 100.00
    end

    def feature_passed? feature
      passed_scenarios(feature).count == feature["elements"].count
    end

    def format_duration(nanoseconds)
      duration_in_seconds = nanoseconds.to_f/1000000000.0
      m, s = duration_in_seconds.divmod(60)
      "#{m}m #{format('%.3f', s)}s"
    end
  end
end
