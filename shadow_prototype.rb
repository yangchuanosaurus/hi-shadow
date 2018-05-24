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
            # find templates
            Pattern.generate_screen(screen_name)
            # iterator each template using screen_name, screen_name_downcase, screen_name_first_letter_uppercase
            # replace by the screen_name
            # see the results
        end

    end
end