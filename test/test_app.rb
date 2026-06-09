require_relative 'test_helper'
require_relative '../app'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  it "returns greeting containing the name for GET /hello/:name" do
    get '/hello/world'
    assert_equal 200, status
    assert_include body, 'world'
    assert_equal "Hello, world!", body
  end

  it "returns greeting containing different names for GET /hello/:name" do
    get '/hello/alice'
    assert_equal 200, status
    assert_include body, 'alice'
    assert_equal "Hello, alice!", body
  end

  it "returns 201 status code when POST /data with valid JSON" do
    header 'Content-Type', 'application/json'
    post '/data', '{"key": "value"}'
    assert_equal 201, status
  end

  it "returns 400 status code when POST /data with invalid JSON" do
    header 'Content-Type', 'application/json'
    post '/data', 'not valid json'
    assert_equal 400, status
  end

  it "returns 404 status code with 'Not found' content for GET /not-exist" do
    get '/not-exist'
    assert_equal 404, status
    assert_include body, 'Not found'
  end
end
