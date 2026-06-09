require 'sinatra/base'
require 'json'

class ApiApp < Sinatra::Base
  get '/' do
    content_type :json
    JSON.generate(app: 'ApiApp', status: 'ok')
  end
end
