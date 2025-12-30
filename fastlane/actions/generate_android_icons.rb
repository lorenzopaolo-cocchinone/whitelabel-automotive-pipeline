module Fastlane
  module Actions

    class GenerateAndroidIconsAction < Action
      def self.run(params)
        res_dir = params[:res_dir]
        icon_src = params[:icon_src]
        
        relative_script_path = File.join(Dir.pwd, "fastlane/lib/generate_icons.sh")
        relative_res_dir = File.join(Dir.pwd, res_dir)

        sh("chmod +x #{relative_script_path}")
        sh("#{relative_script_path} --res_dir=#{res_dir} --icon_src=#{icon_src}")

      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :res_dir,
            description: "Where to save generated icon, default should be src/main/res/",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :icon_src,
            description: "Icon in .png that need to be transformed in icons",
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
