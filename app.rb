require 'json'
require 'sinatra'

get '/hello/:name' do
  "Hello #{params[:name]}!"
end

post '/data' do
  JSON.parse(request.body.read)
  status 201
  ''
rescue JSON::ParserError
  halt 400, 'Bad Request'
end

not_found do
  status 404
  'Not found'
end
