require 'sinatra'
require 'json'

get '/hello/:name' do
  "Hello #{params[:name]}!"
end

post '/data' do
  begin
    JSON.parse(request.body.read)
    status 201
  rescue JSON::ParserError
    status 400
  end
end

not_found do
  "Not found"
end
