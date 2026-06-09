require 'sinatra/base'

class App < Sinatra::Base
  get '/hello/:name' do
    "Hello, #{params[:name]}!"
  end

  post '/data' do
    content_type :json
    begin
      request.body.rewind
      JSON.parse(request.body.read)
      status 201
      { status: 'created' }.to_json
    rescue JSON::ParserError
      status 400
      { error: 'invalid JSON' }.to_json
    end
  end

  not_found do
    status 404
    'Not found'
  end
end
