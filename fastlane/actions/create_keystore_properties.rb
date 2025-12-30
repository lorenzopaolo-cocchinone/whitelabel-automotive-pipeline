module Fastlane
  module Actions

    require 'fileutils'
    class CreateKeystorePropertiesAction < Action
      def self.run(params)
        keystore_info = params[:keystore_info]
        keystore_src = params[:keystore_src]

        UI.user_error!("Missing KeyStore Info") unless keystore_info
        UI.user_error!("Missing KeyStore path") unless keystore_src

        # TODO here we need to decypt the keystore, the store_password and key_password
        # TODO ########################################################################
        # TODO ########################################################################

        store_password = keystore_info[:storePassword]
        key_password = keystore_info[:key_password]

        project_root_folder = Dir.pwd
        keystore_properties_path = File.join(project_root_folder, "keystore.properties")

        File.open(keystore_properties_path, "w") do |file|
          file.puts "keystore.password=#{keystore_info[:storePassword]}"
          file.puts "keystore.key.alias=#{keystore_info[:keystoreAlias]}"
          file.puts "keystore.key.password=#{keystore_info[:keyPassword]}"
        end

        UI.success("keystore.properties generated successfully!")
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
            key: :keystore_src,
            description: "Keystore path that need to be used for keystore.properties",
            optional: true,
            type: String
          ),
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
