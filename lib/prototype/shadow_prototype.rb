require_relative 'shadow_pattern'

module ShadowSolution
    MVP = "mvp"
    MVC = "mvc"

    class Prototype
        @@pattern = MVP

        def self.using(pattern)
            @@pattern = pattern
            puts "Prototype Pattern didSet #{pattern}"
        end

        def self.pattern
            @@pattern
        end

        def self.create_screen(screen_name)
            puts "Prototype create screen #{screen_name}"
            Pattern.generate_screen(screen_name)
        end

    end
end