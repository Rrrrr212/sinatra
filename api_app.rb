require 'sinatra/base'

class ApiApp < Sinatra::Base
  get '/' do
    'Api App'
  end
end
