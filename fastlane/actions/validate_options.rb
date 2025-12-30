module Fastlane
  module Actions
    module SharedValues
      API_KEY = :API_KEY
      BASE_URL = :BASE_URL
    end

    class ValidateOptionsAction < Action
      def self.run(params)
        job_id = params[:job_id]
        api_key = params[:api_key]
        base_url = params[:base_url]

        if job_id.nil? || job_id.empty?
          UI.user_error!("Missing Job Identification, make sure to call this lane with job_id:\"ID\"")
        end

        if api_key.nil? || api_key.empty?
          UI.user_error!("Missing API key, make sure to call this lane with api_key:\"KEY\"")
        end

        if base_url.nil? || base_url.empty?
          UI.user_error!("Missing CMS Base URL, make sure to call this lane with base_url:\"URL\"")
        end

        begin
          uri = URI.parse(base_url)
          unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
            UI.user_error!("Invalid CMS Base URL, it must be a valid HTTP/HTTPS URL")
          end
        rescue URI::InvalidURIError
          UI.user_error!("Invalid CMS Base URL, it must be a valid URL")
        end

        # Actions.lane_context[SharedValues::API_KEY] = api_key
        # Actions.lane_context[SharedValues::BASE_URL] = base_url

        # ENV["FL_API_KEY"] = api_key
        # ENV["FL_CMS_BASE_URL"] = base_url

        UI.message("Environment configured correctly!")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :job_id,
            description: "Pipeline Job Identification for updating status",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :api_key,
            description: "CMS API key for Authentication",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :base_url,
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
