module Fastlane
  module Actions
    module SharedValues
      REPLACE_SPLASHSCREEN_CUSTOM_VALUE = :REPLACE_SPLASHSCREEN_CUSTOM_VALUE
    end

    class ReplaceSplashscreenAction < Action
      def self.run(params)

        drawable_dir = params[:drawable_dir]
        splashscreen_src = params[:splashscreen_src]
        
        relative_drawable_dir = File.join(Dir.pwd, drawable_dir)

        UI.message("Copying splash screen into #{relative_drawable_dir}")

        unless File.exist?(splashscreen_src)
          UI.user_error!("Splashscreen.gif file not found: #{splashscreen_src}")
        end

        unless File.extname(splashscreen_src).downcase == ".gif"
          UI.user_error!("Splashscreen must be a .gif file (got #{File.extname(splashscreen_src)})")
        end
        
        unless Dir.exist?(relative_drawable_dir)
          UI.user_error!("Drawable directory does not exist: #{relative_drawable_dir}")
        end

        splash_dest = File.join(relative_drawable_dir, "splash_onboarding.gif")
        FileUtils.cp(splashscreen_src, splash_dest)

        UI.success("✅ Splash screen copied to #{splash_dest}")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :drawable_dir,
            description: "Android Resource folder, default should be src/main/res/",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :splashscreen_src,
            description: "Splashscreen in .gif that need to be used",
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
