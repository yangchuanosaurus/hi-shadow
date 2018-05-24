require_relative 'shadow_project'

module Shadow

    class Command

        def self.init(*params)
            logger = ZeroLogger.logger("main")
            project = Shadow::Project.new
            project.init
        end

        def self.prototype(*params)
            logger = ZeroLogger.logger("main")
            logger.begin('shadow prototype')

            if params.empty? || params.size < 2
                logger.add_error("wrong argument of `prototype`")
                return
            end

            prototype_type = params[0]
            prototype_name = params[1]

            logger.level += 1
            PrototypeCommand.screen(prototype_name)
        end
    end

    class PrototypeCommand

        def self.screen(screen_name)
            logger = ZeroLogger.logger("main")
            logger.add_msg("create prototype `#{screen_name}` of `prototype`")
        end
        
    end

end