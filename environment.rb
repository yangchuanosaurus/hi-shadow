require 'httparty'
require 'cgi'

class Environment
    @@groups = {}

    def self.new_group(name)
        group = EnvironmentGroup.new(name)
        @@groups[name] = group
        return group
    end

    def self.print()
        @@groups.each do |name, group|
            puts "EnvironmentGroup #{name}"
            group.enviroments.each do |env, url|
                printf "%10s: %s\n", env, url
            end
        end
    end

    def self.group(name)
        @@groups[name]
    end
end

class EnvironmentGroup
    attr_reader :enviroments, :url

    def initialize(name)
        @name = name
        @enviroments = {}
    end

    def add(env, url)
        @enviroments[env] = url
        self
    end

    def using(env)
        RunAction.new(@enviroments[env])
    end
end

class RunAction
    # include HTTParty
    # debug_output $stdout

    def initialize(base_url)
        @base_url = base_url
    end

    def run(action, &block)
        # get the callback from remote service
        remote_url = action.url(@base_url)

        puts "===> #{action.http_method} #{remote_url}"
        # disable the redirects follow the config in action
        response = HTTParty.send(action.http_method, remote_url, follow_redirects: action.redirects)

        puts "<=== #{action.action_alias}"
        printf "%+20s %s\n", 'Response Code:', response.code
        printf "%+20s %s\n", 'Response Message:', response.message
        yield(response.headers, response.body) if !block.nil?
        response
    end
end

class Action
    attr_reader :path

    def initialize(http_method, path, hsh = {})
        @http_method = http_method
        @path = path
        @request = hsh
        @redirects = true
    end

    def inject(hsh = {})
        hsh.each do |key, child_hsh|
            key_request = @request[key]
            key_request = {} if key_request.nil?
            key_request = key_request.merge(child_hsh)
            @request[key] = key_request
        end
        self
    end

    def redirects
        header["follow_redirects"]
    end

    def alias(action_alias, info)
        @alias = action_alias
        @info = info
        self
    end

    def action_alias
        if @alias.nil?
            return "#{@http_method} #{@path}"
        else
            return "#{@http_method} #{@alias}"
        end
    end

    def http_method
        @http_method
    end

    def print_requests()
        if !@alias.nil?
           puts @alias 
        end
        @request.each do |key, h|
            printf "%10s:\n", key
            printf "%7s %s\n", '', h
        end
    end

    def url(base_url)
        query_items = []
        if !query.nil?
            query.each do |key, hsh|
                query_item = "#{key}=#{CGI::escape(hsh)}"
                query_items.push(query_item)
            end
        end
        if query_items.length > 0
            query_http = query_items.join('&')
            return "#{base_url}#{@path}?#{query_http}"
        end
        return base_url
    end

    def header
        @request[:header]
    end

    private

    def query
        @request[:query]
    end

    def body
        @request[:body]
    end
end

class UrlSchema
    def self.params(url)
        return {} if url.nil?
        CGI.parse(URI(url).query)
    end
end