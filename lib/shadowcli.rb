module Shadow

    class Command

        def self.init(*params)
            logger = ZeroLogger.logger("main")
            project = Project.new
            project.init
        end
    end

end