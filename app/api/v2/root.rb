require 'grape-swagger'

module V2
  class Root < Grape::API

    version 'v2'
    format :json
    content_type :json, "application/json;charset=UTF-8"
    formatter :json, Grape::Formatter::Jbuilder

    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end

    get "test" do
      {test: :ok}
    end

    add_swagger_documentation base_path: "/api", api_version: 'v2', mount_path: 'doc.json'
  end
end