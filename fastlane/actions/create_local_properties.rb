module Fastlane
  module Actions

    require 'fileutils'
    class CreateLocalPropertiesAction < Action
      def self.run(params)
        config_data = params[:application_config]
        UI.user_error!("Config JSON not found. Make sure to run get_config_data first.") if config_data == nil

        project_root = File.expand_path("../..", __dir__)
        local_properties_path = File.join(project_root, "local.properties")
        UI.message("Generating #{local_properties_path} ...")

        # TODO add verification of single field
        File.open(local_properties_path, "w") do |file|
          file.puts
          # RadioConnect Credentials
          file.puts "########## RadioConnect Credentials ##########"
          file.puts "radioconnect.api.broadcaster.username=#{config_data[:radioconnectApiBroadcasterUsername]}"
          file.puts "radioconnect.api.broadcaster.password=#{config_data[:radioconnectApiBroadcasterPassword]}"
          file.puts "radioconnect.api.base.url=#{config_data[:radioconnectBaseUrl]}"
          file.puts

          # Didomi Credentials
          file.puts "########## Didomi Credentials ##########"
          file.puts "didomi.api.key=#{config_data[:didomiApiKey] || ""}"
          file.puts "didomi.notice.id=#{config_data[:didomiNoticeId] || ""}"
          file.puts

          # Package Info
          file.puts "########### Package Info ##########"
          file.puts "application.id=#{config_data[:applicationId]}"
          file.puts "application.name=#{config_data[:applicationName]}"
          file.puts

          # Versioning
          file.puts "########### Versioning ##########"
          file.puts "white.label.generated.id=#{config_data[:whiteLabelGeneratedId]}"
          file.puts "version.code=#{config_data[:versionCode]}"
          file.puts "version.name=#{config_data[:versionName]}"
          file.puts

          # Feature Flags
          file.puts "########### Feature Flags ##########"
          file.puts "feature.search.enabled=#{config_data[:featureSearchEnabled]}"
          file.puts "feature.didomi.enabled=#{config_data[:featureDidomiEnabled]}"
          file.puts

          # Customization
          file.puts "########### Customization ##########"
          file.puts "accent.color=#{config_data[:accentColor]}"
          file.puts


          # Customization
          file.puts "########### Remote Config ##########"
          file.puts "aws.base.url=#{config_data[:configUrl]}"
        end

        # sh "mv local.properties ../"
        UI.success("local.properties generated successfully!")
      end

      def self.available_options
        [
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
