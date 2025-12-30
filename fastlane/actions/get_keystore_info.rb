module Fastlane
  module Actions
    module SharedValues
      KEYSTORE_INFO = :KEYSTORE_INFO
    end

    class GetKeystoreInfoAction < Action
      def self.run(params)
        api_key = params[:api_key]
        base_url = params[:base_url]
        endpoint = params[:endpoint]
        
        UI.user_error!("Missing API key") if api_key.nil? || api_key.strip.empty?
        UI.user_error!("Missing Endpoint") if endpoint.nil? || endpoint.strip.empty?
        UI.user_error!("Missing CMS Base url") if base_url.nil? || base_url.strip.empty?

        url = "#{base_url}/#{endpoint}"
        response = HTTParty.get(url, headers: {
          "Authorization" => "Bearer #{api_key}",
          "Content-Type" => "application/json"
        })

        json_data = response.parsed_response
        keystore_info = json_data.transform_keys(&:to_sym)

        Actions.lane_context[SharedValues::KEYSTORE_INFO] = keystore_info
        UI.message("Keystore info Saved in SharedValue!")
      end


      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :endpoint,
            description: "CMS Endpoint for keystore info",
            optional: true,
            type: String
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
