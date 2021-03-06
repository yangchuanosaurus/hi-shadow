require_relative 'shadow_file_utils'

module ShadowSolution
    
    PATTERN_RELATIVE_PATH = "/../.././pattern"
    PATTERN_BASE_PATH = File.dirname(__FILE__) + PATTERN_RELATIVE_PATH
    PATTERN_RECIPE = "./recipe.yml"

    class Pattern

        def self.generate_screen(screen_name)
            pattern_path = "#{PATTERN_BASE_PATH}/#{Prototype.pattern}"
            pattern_recipe_path = "#{pattern_path}/#{PATTERN_RECIPE}"

            puts "Using pattern: #{pattern_path}"
            puts "Recipe: #{pattern_recipe_path}"

            # find templates
            recipe_dash = ShadowFileUtils.load_yaml(pattern_recipe_path)
            recipe_dash.each do |pattern_node|
                pattern_node_name = pattern_node[0]
                pattern_node_channel = pattern_node[1]
                pattern_channel = PatternChannel.new(screen_name, pattern_node_name, pattern_node_channel)
                pattern_channel.apply
            end
        end

    end

    class PatternChannel
        SCREEN_NAME = "screen_name"
        PACKAGE_NAME = "package_name"

        def initialize(screen_name, name, channel_dash)
            @screen_name = screen_name
            @name = name
            @channel_dash = channel_dash
            @package_name = Package.name
        end

        def apply
            pattern_path = "#{PATTERN_BASE_PATH}/#{Prototype.pattern}"

            pattern_node_channel_from = @channel_dash[:from]
            pattern_node_channel_to = @channel_dash[:to]
            puts "Apply screen: #{pattern_node_channel_from}"
            
            # find what's vars need be replace, and what's the replacing consts
            occurs = find_var_occurs(pattern_node_channel_to)
            #puts "---->1#{occurs}"
            to_file_name = pattern_node_channel_to
            occurs.each do |var|
                text_vars = pickup_vars(var)
                #puts "---->2#{text_vars}"
                text_vars.each do |text_var|
                    case_method = pickup_var_method(text_var)
                    text_var_name = text_var.gsub case_method, ''
                    if case_method.nil? || case_method.length == 0
                        replacing = send(text_var_name)
                    else
                        replacing = send(case_method, send(text_var_name))
                    end
                    text_var_in_tags = "${#{text_var}}"
                    #puts "---->3#{to_file_name} #{text_var_in_tags} #{replacing}"
                    to_file_name = remove_var_tags_and_replacing(to_file_name, text_var_in_tags, replacing)
                end
                
                # specific the path of creating file
            end

            # got the file name to_file_name

            #get the template code
            from_file = "#{pattern_path}/./#{pattern_node_channel_from}"
            content = ShadowFileUtils.load(from_file)
            vars_in_content = find_var_occurs(content)
            content_updated = content
            vars_in_content.each do |var_in|
                text_vars_in = pickup_vars(var_in)
                text_var_in = text_vars_in[0]
                case_method_in = pickup_var_method(text_var_in)
                text_var_name_in = text_var_in.gsub case_method_in, ''
                if case_method_in.nil? || case_method_in.length == 0
                    replacing_in = send(text_var_name_in)
                else
                    replacing_in = send(case_method_in, send(text_var_name_in))
                end
                
                text_var_in_tags = "${#{text_var_in}}"
                content_updated = remove_var_tags_and_replacing(content_updated, text_var_in_tags, replacing_in)
            end

            ShadowFileUtils.write_content(to_file_name, content_updated)
            puts "===> #{to_file_name} created."
        end

        def find_var_occurs(str)
            str.scan(/\$\{\w+\}/)
        end

        def pickup_vars(str_includes_tags)
            str_includes_tags.scan(/\w+/)
        end

        def pickup_var_method(f)
            f = f.gsub SCREEN_NAME, ''
            f = f.gsub PACKAGE_NAME, ''
        end

        def remove_var_tags_and_replacing(str_full, var, replacing)
            to_file_name = str_full.gsub var, replacing
            #to_file_name = to_file_name.sub /(\$\{)|\}/, ''
            to_file_name
        end

        def remove_all_tags(str)
            str.gsub /(\$\{)|\}/, ''
        end

        def _downcase(str)
            str.downcase
        end

        def _first_letter_uppercase(str)
            str[0].upcase  + str[1..-1].downcase
        end

        def screen_name
            @screen_name
        end

        def package_name
            @package_name
        end

        def _to_path(str) #com.a.b.c => com/a/b/c
            str.split('.').join('/')
        end
    end
end