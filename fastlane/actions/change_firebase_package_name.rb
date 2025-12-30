module Fastlane
  module Actions

    class ChangeFirebasePackageNameAction < Action
      def self.run(params)
        application_config = params[:application_config]
        firebase_json_path = params[:firebase_json_path]

        package_name = application_config[:applicationId]
        UI.user_error!("Missing google-services.json path") unless firebase_json_path
        UI.user_error!("Missing Application Name in Application Config JSON") unless package_name

        relative_firebase_json_path = File.join(Dir.pwd, firebase_json_path)
        UI.message("Modifying Firebase Json at #{relative_firebase_json_path} with package name: #{package_name}")

        content = File.read(relative_firebase_json_path)

        # TODO for now need to be hardcoded because we share the json with RPAW
        updated_content = content.gsub(
          /("android_client_info"\s*:\s*{\s*"package_name"\s*:\s*")org\.radioplayer\.whitelabel[^"]*(")/,
          "\\1#{package_name}\\2"
        )

        File.write(relative_firebase_json_path, updated_content)
        UI.success("Package name updated successfully in firebase.json!")
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
            key: :firebase_json_path,
            description: "Firebase google-services.json path",
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
