module Fastlane
  module Actions

    class ChangeApplicationNameAction < Action
      def self.run(params)
        strings_path = params[:strings_path]
        application_config = params[:application_config]

        application_name = application_config[:applicationName]
        UI.user_error!("Missing strings.xml path") unless strings_path
        UI.user_error!("Missing Application Name in Application Config JSON") unless application_name

        relative_strings_path = File.join(Dir.pwd, strings_path)
        UI.message("Modifying strings.xml at #{relative_strings_path} with application name: #{application_name}")
        
        content = File.read(relative_strings_path)
        updated_content = content.gsub(/<string name="app_name">.*?<\/string>/, "<string name=\"app_name\">#{application_name}</string>")
        File.write(relative_strings_path, updated_content)

        UI.success("Application name updated successfully in strings.xml!")
      end

      def self.available_options
        [
           FastlaneCore::ConfigItem.new(
            key: :application_config,
            description: "Application Config JSON",
            optional: true,
            type: Hash
          ),
          FastlaneCore::ConfigItem.new(
            key: :strings_path,
            description: "Strings.xml resource path",
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
