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
      report_file = open("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{KrakenMobile::Constants::REPORT_DEVICES_FILE_NAME}.json")
      content = report_file.read
      report_file.close
      @devices = JSON.parse(content)
      devices_report = report_by_devices(@devices)
      @features_report = fetures_from_report_by_devices devices_report
      data_hash = feature_by_nodes_and_links @features_report
      file = open("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/assets/js/#{KrakenMobile::Constants::D3_DATA_FILE_NAME}.json", 'w')
      file.puts(data_hash.to_json)
      file.close
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
      report_file.close
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
        next if !File.exists?("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device['id']}/#{KrakenMobile::Constants::REPORT_FILE_NAME}.json")
        report_file = open("#{KrakenMobile::Constants::REPORT_PATH}/#{@execution_id}/#{device['id']}/#{KrakenMobile::Constants::REPORT_FILE_NAME}.json")
        content = report_file.read
        report_file.close
        devices_report[device['user']] = JSON.parse(content)
        devices_report[device['user']].each do |d| d["device_model"] = device["model"] if !d["device_model"] end
        devices_report[device['user']].each do |d| d["device_id"] = device["id"] if !d["device_id"] end
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
          features[feature["id"]]["devices"] = {} if !features[feature["id"]]["devices"]
          if feature["elements"] && feature["elements"].count > 0
            features[feature["id"]]["devices"][user_key] = []
            if feature["elements"].first["steps"]
              failed = false
              feature["elements"].first["steps"].each do |step|
                next if failed
                failed = step["result"]["status"] != PASSED
                image = nil
                image = step["after"].first["embeddings"].first["data"] if step["after"] && step["after"].count > 0 && step["after"].first["embeddings"] && step["after"].first["embeddings"].count > 0
                features[feature["id"]]["devices"][user_key] << {
                  name: "#{step['keyword']} #{step['name']}",
                  duration: step["result"]["duration"],
                  image: image,
                  device_model: feature["device_model"],
                  status: failed ? FAILED : PASSED
                }
              end
            end
          end
        end
      end
      features
    end

    def feature_by_nodes_and_links features_report
      features = []
      features_report.values.each do |feature|
        features << nodes_and_links(feature["devices"], feature["name"]) if feature["devices"]
      end
      features
    end

    def nodes_and_links feature_report, feature_name
      last_node_id = 0
      nodes = [{ name: "", id: "empty", image: nil }]
      signal_hash = {}
      links = []
      feature_report.keys.each do |key|
        steps = feature_report[key]
        coming_from_signal = false
        last_signal = -1
        steps.each_with_index do |step, index|
          node_id = last_node_id+1
          if isReadSignal(step[:name]) && step[:status] == PASSED
            signal = signalContent(step[:name])
            already_created_signal = signal_hash[signal] ? true : false
            signal_hash[signal] = already_created_signal ? signal_hash[signal] : { id: "#{node_id}", receiver: key }
            node = { name: "Signal: #{signal}, Receiver: #{step[:device_model]}", id: signal_hash[signal][:id], image: nil, status: step[:status] }
            if already_created_signal
              entry = nodes.select{ |node| node[:id] == signal_hash[signal][:id] }.first
              entry[:name] = "Signal: #{signal}, Receiver: #{step[:device_model]}" if entry
            end
            source = (coming_from_signal ? last_signal : (index == 0 ? 0 : last_node_id))
            link = {
              source: source,
              target: signal_hash[signal][:id].to_i,
              value: 1,
              owner: key,
              owner_model: step[:device_model]
            }
            nodes << node if !already_created_signal
            links << link
            last_node_id += 1 if !already_created_signal
            last_signal = signal_hash[signal][:id].to_i
            coming_from_signal = true
          elsif isWriteSignal(step[:name]) && step[:status] == PASSED
            signal = signalContent(step[:name])
            receiver = signalReceiver(step[:name])
            already_created_signal = signal_hash[signal] ? true : false
            signal_hash[signal] = already_created_signal ? signal_hash[signal] : { id: "#{node_id}", receiver: receiver }
            node = { name: step[:name], id: signal_hash[signal][:id], image: nil, status: step[:status] }
            source = (coming_from_signal ? last_signal : (index == 0 ? 0 : last_node_id))
            link = {
              source: source,
              target: signal_hash[signal][:id].to_i,
              value: 1,
              owner: key,
              owner_model: step[:device_model]
            }
            nodes << node if !already_created_signal
            links << link
            last_node_id += 1 if !already_created_signal
            last_signal = signal_hash[signal][:id].to_i
            coming_from_signal = true
          else
            node = { name: step[:name], id: "#{node_id}", image: step[:image], status: step[:status] }
            source = (coming_from_signal ? last_signal : (index == 0 ? 0 : last_node_id))
            link = {
              source: source,
              target: node_id,
              value: 1,
              owner: key,
              owner_model: step[:device_model]
            }
            nodes << node
            links << link
            last_node_id += 1
            coming_from_signal = false
          end
        end
      end
      return {
        name: feature_name,
        nodes: nodes,
        links: links
      }
    end

    def isReadSignal step
      line = step.split(' ')[1..-1].join(' ')
      (line =~ /^I wait for a signal containing "([^\"]*)"$/ ? true : false) || (line =~ /^I wait for a signal containing "([^\"]*)" for (\d+) seconds$/ ? true : false)
    end

    def isWriteSignal step
      line = step.split(' ')[1..-1].join(' ')
      line =~ /^I send a signal to user (\d+) containing "([^\"]*)"$/ ? true : false
    end

    def signalContent step
      line = step.split(' ')[1..-1].join(' ')
      line.scan(/"([^\"]*)"/).first.first if line.scan(/"([^\"]*)"/).first
    end

    def signalReceiver step
      line = step.split(' ')[1..-1].join(' ')
      line.scan(/(\d+)/).first.first if line.scan(/(\d+)/).first
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
        how_long += step["result"]["duration"] if step["result"] && step["result"]["duration"]
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
