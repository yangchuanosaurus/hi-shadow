require 'yaml'
require 'fileutils'

module Shadow
    class ShadowFileUtils

        def self.exists?(file_name)
            File.exists?(file_name)
        end

        def self.load_yaml(relative_file_path)
            YAML.load_file(relative_file_path)
        end
        
    end
end