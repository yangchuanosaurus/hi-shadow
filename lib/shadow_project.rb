require_relative 'core/shadow_fileutils'

module Shadow

    class Project

        SHADOW_FILE = './shadow.yml'
        TEMPLATE_OF_PROJECT_FILE = File.dirname(__FILE__) + '/../templates/project.yml'

        def init
            logger = ZeroLogger.logger("main")
            logger.begin('init as a shadow project')
            logger.level += 1
            
            if !ShadowFileUtils.exists?(TEMPLATE_OF_PROJECT_FILE)
                logger.add_error("Cannot find the project template file.")
				return
            end

            project_dash = load_project
            ShadowFileUtils.write(SHADOW_FILE, project_dash)
            logger.add_msg("#{SHADOW_FILE} created.")
        end

        private
		def load_project
			if ShadowFileUtils.exists?(SHADOW_FILE)
				dash =  ShadowFileUtils.load_yaml(SHADOW_FILE)
				fill_project_name(dash)
				return dash
			else
				return load_project_template
			end
		end

		def load_project_template
			project_template_dash = ShadowFileUtils.load_yaml(TEMPLATE_OF_PROJECT_FILE)
			fill_project_name(project_template_dash)

			project_template_dash
		end

        def fill_project_name(project_dash)
			project_dash[:name] = File.basename(Dir.getwd)
		end
        
    end

end