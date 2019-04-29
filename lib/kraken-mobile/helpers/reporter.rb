require 'kraken-mobile/constants'

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
