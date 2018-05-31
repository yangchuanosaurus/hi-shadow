#!/usr/bin/env ruby

require_relative 'environment'

env_group_default = "default"

# 1. Setup environment urls for "Passport"
Environment.new_group(env_group_default) # Passport Environment
    .add("PINT", "https://passportui-vip.int.aw.dev.activenetwork.com")
    .add("INT", "https://passportui-vip.pint.aw.dev.activenetwork.com")
    .add("QA", "https://passportui-vip.qa.aw.dev.activenetwork.com")
    .add("REG", "https://passportui-vip.reg.aw.dev.activenetwork.com")
    .add("STAGE", "https://passportui-vip.stage.aw.dev.activenetwork.com")
    .add("PROD", "https://passport.active.com")

Environment.new_group("mobile") # Mobile Environment
    .add("PINT", "https://awmobile-vip.pint.aw.dev.activenetwork.com")
    .add("INT", "https://awmobile-vip.int.aw.dev.activenetwork.com")
    .add("QA", "https://awmobile-vip.qa.aw.dev.activenetwork.com")
    .add("REG", "https://awmobile-vip.reg.aw.dev.activenetwork.com")
    .add("STAGE", "https://awmobile-vip.stage.aw.dev.activenetwork.com")
    .add("PROD", "https://awmobile.active.com")

# 2. Configure the biz data
request_data_auth_code = { # the values bellow are final static datum
    "client_id" => "15e751e7-837d-4313-bc50-3cf75c4d2edf",
    "force_redirect" => "true",
    "redirect_uri" => "http://app.laxpower.com",
    "remember" => "false",
    "response_type" => "code"
}

# # 3. Configure the endpoint request
sample_query = {
    "username" => "albertdev@qa.com",
    "password" => "aaaaaa"
}

request_headers = {
    "follow_redirects" => false
}

action_auth_code = Action.new("get", "/oauth2/authorize", {header: request_headers, query: sample_query})
    .inject({query: request_data_auth_code})
    .alias("endpoint_auth_code", "the endpoint allows client fetch authcode by username and password")

# 4. Test the endpoint and add biz logic in block
Environment.group(env_group_default).using("QA").run(action_auth_code) do |headers, body|
    # 5. biz logic about parse remote data
    redirects_location = headers["location"]
    params = UrlSchema.params(redirects_location)
    
    if params.nil? || params.empty?
        puts "[Biz] Cannot find the redirects location in response headers. Or no params in the location."
    else
        puts "[Biz] found the redirects_location"
        error_code = params["errorcode"]
        if error_code.nil? || error_code.empty?
            params.each do |name, value|
                printf "%10s= %s\n", name, value
            end
            puts "Response Headers:"
            headers.each do |h_k, h_v|
                printf "%30s= %s\n", h_k, h_v
            end
            puts "Response Body:"
            puts body.inspect
        else
            puts "[Biz] error #{error_code}"
        end
    end
end

# response = Environment.group("default").using("QA").run(action_auth_code)