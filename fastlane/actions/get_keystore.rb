module Fastlane
  module Actions

    require 'httparty'
    require 'fileutils'
    require 'tmpdir'

    class GetKeystoreAction < Action
      def self.run(params)
        api_key = params[:api_key]
        base_url = params[:base_url]
        keystore_info = params[:keystore_info]
        
        UI.user_error!("Missing API key") unless api_key
        UI.user_error!("Missing CMS Base url") unless base_url
        UI.user_error!("Missing KeyStore Info") unless keystore_info

        keystore_dir = Dir.pwd
        UI.message("Saving keystore in: #{keystore_dir}")

        url = "#{keystore_info[:jksURI]}"
        response = HTTParty.get(url, headers: {
          "Authorization" => "Bearer #{api_key}",
          "Content-Type" => "application/json"
        })

        file_path = File.join(keystore_dir, "keystore#{File.extname(url)}")
        UI.message("Downloading keystore from #{url}...")

        if response.success?
          File.open(file_path, "wb") { |f| f.write(response.body) }
          UI.success("Keystore saved at #{file_path}")
        else
          UI.error("Failed to download keystore from #{url}")
        end
        
        file_path
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :keystore_info,
            description: "KeyStore Info",
            optional: true,
            type: Hash
          ),
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
          )
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
