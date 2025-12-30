module Fastlane
  module Actions
    module SharedValues
      ASSETS_TEMP_FOLDER = :ASSETS_TEMP_FOLDER
    end

    class DownloadAssetsAction < Action
      require 'httparty'
      require 'fileutils'
      require 'tmpdir'

      def self.run(params)
        api_key = params[:api_key]
        base_url = params[:base_url]
        application_config = params[:application_config]

        UI.user_error!("Missing API key") unless api_key
        UI.user_error!("Missing CMS Base url") unless base_url
        UI.user_error!("Config JSON not found. Make sure to run get_config_data first.") unless application_config

        tmp_dir = Dir.mktmpdir("../assets_tmp_")
        UI.message("Saving assets in temporary folder: #{tmp_dir}")
        Actions.lane_context[SharedValues::ASSETS_TEMP_FOLDER] = tmp_dir

        downloaded_files = {}

        { icon: application_config[:iconURI], splash: application_config[:splashScreenURI] }.each do |name, url|
          UI.message("#{name} URL: #{url.inspect}") 
          next unless url && !url.empty?

          file_path = File.join(tmp_dir, "#{name}#{File.extname(url)}")
          UI.message("Downloading #{name} from #{url}...")

          response = HTTParty.get(url,
          headers: {
            "Authorization" => "Bearer #{api_key}",
            "Content-Type" => "application/json"
          })

          if response.success?
            File.open(file_path, "wb") { |f| f.write(response.body) }
            downloaded_files[name] = file_path
            UI.success("#{name} saved at #{file_path}")
          else
            UI.error("Failed to download #{name} from #{url}")
          end
        end

        { files: downloaded_files }
      end


      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :api_key,
            env_name: "API_KEY",
            description: "CMS API key for Authentication",
            optional: true,
            type: String
          ),

          FastlaneCore::ConfigItem.new(
            key: :base_url,
            env_name: "BASE_URL",
            description: "CMS Url",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :application_config,
            description: "Application Config JSON",
            optional: true,
            type: Hash
          )
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
