require_relative 'test_helper'
require 'json'

class TestApp < Minitest::Test
  def setup
    mock_app do
      get '/hello/:name' do
        "Hello #{params[:name]}!"
      end

      post '/data' do
        begin
          request.body.rewind
          json_data = JSON.parse(request.body.read)
          status 201
          "Data received successfully"
        rescue JSON::ParserError
          status 400
          "Invalid JSON"
        end
      end

      not_found do
        status 404
        "Not found"
      end
    end
  end

  # Test GET /hello/:name
  it "returns correct greeting for /hello/:name" do
    get '/hello/world'
    assert_equal 200, status
    assert_includes body, 'world'
    assert_equal 'Hello world!', body
  end

  it "returns greeting with different names" do
    get '/hello/Sinatra'
    assert_equal 200, status
    assert_includes body, 'Sinatra'
    assert_equal 'Hello Sinatra!', body
  end

  # Test POST /data with valid JSON
  it "returns 201 when sending valid JSON to /data" do
    post '/data', JSON.generate({name: 'test', value: 123})
    assert_equal 201, status
  end

  it "returns success message when sending valid JSON to /data" do
    post '/data', JSON.generate({name: 'test', value: 123})
    assert_equal 'Data received successfully', body
  end

  # Test POST /data with invalid JSON
  it "returns 400 when sending invalid JSON to /data" do
    post '/data', 'this is not json'
    assert_equal 400, status
  end

  it "returns error message when sending invalid JSON to /data" do
    post '/data', 'this is not json'
    assert_equal 'Invalid JSON', body
  end

  # Test GET /not-exist (404 handling)
  it "returns 404 for non-existent routes" do
    get '/not-exist'
    assert_equal 404, status
  end

  it "returns custom 404 page with 'Not found' content" do
    get '/not-exist'
    assert_includes body, 'Not found'
  end

  it "returns 404 for any undefined route" do
    get '/this-route-does-not-exist'
    assert_equal 404, status
    assert_includes body, 'Not found'
  end
end