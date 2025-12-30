
module Fastlane
  module Actions

    require 'httparty'
    class UpdateBuildStatusAction < Action
      def self.run(params)
        status = params[:status]
        job_id = params[:job_id]
        api_key = params[:api_key]
        message = params[:message]
        base_url = params[:base_url]

        UI.user_error!("Missing API key") unless api_key
        UI.user_error!("Missing CMS Base url") unless base_url
        UI.user_error!("UpdateBuildStatusAction called without a status param") unless status
        UI.user_error!("UpdateBuildStatusAction called without a status job_id") unless job_id

        payload = {
          jobId: job_id,
          status: status.to_s(),
          updatedAt: Time.now.utc.iso8601  # timestamp ISO8601
        }
        payload[:message] = message if message

        response = HTTParty.post(
          "#{base_url}/webhook/pipeline",
          headers: {
            "Authorization" => "Bearer #{api_key}",
            "Content-Type" => "application/json"
          },
          body: payload.to_json
          )

        UI.message("Response: #{response.body}")

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
            key: :status,
            description: "New Status",
            optional: true,
            type: Enums::Status
          ),
          FastlaneCore::ConfigItem.new(
            key: :message,
            description: "Optional Message",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :job_id,
            description: "Pipeline Job ID",
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
