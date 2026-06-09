require 'sinatra'
require 'json'

# GET /hello/:name - Returns a greeting with the name
get '/hello/:name' do
  "Hello #{params[:name]}!"
end

# POST /data - Validates JSON and returns appropriate status codes
post '/data' do
  begin
    # Attempt to parse the request body as JSON
    request.body.rewind
    json_data = JSON.parse(request.body.read)
    # If successful, return 201 Created
    status 201
    "Data received successfully"
  rescue JSON::ParserError
    # If JSON parsing fails, return 400 Bad Request
    status 400
    "Invalid JSON"
  end
end

# Custom 404 handler for non-existent routes
not_found do
  status 404
  "Not found"
end