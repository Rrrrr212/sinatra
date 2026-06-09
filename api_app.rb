require 'sinatra/base'

class ApiApp < Sinatra::Base
  get '/' do
    'API Root'
  end

  get '/version' do
    '{"version": "1.0"}'
  end
end
