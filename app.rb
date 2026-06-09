require 'sinatra/base'
require 'json'

class App < Sinatra::Base
  set :environment, :production
  set :show_exceptions, false
  set :raise_errors, false

  get '/hello/:name' do
    "Hello, #{params['name']}!"
  end

  post '/data' do
    begin
      data = JSON.parse(request.body.read)
    rescue JSON::ParserError
      status 400
      return 'Bad Request: Invalid JSON'
    end

    status 201
    'Created'
  end

  not_found do
    status 404
    'Not found'
  end
end
