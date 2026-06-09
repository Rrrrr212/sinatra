require 'minitest/autorun'
require 'rack/test'
require_relative '../app'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_hello_name
    get '/hello/world'
    assert_equal 200, last_response.status
    assert_includes last_response.body, 'world'
  end

  def test_post_data_valid_json
    post '/data', { key: 'value' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    assert_equal 201, last_response.status
  end

  def test_post_data_invalid_json
    post '/data', 'invalid json', { 'CONTENT_TYPE' => 'application/json' }
    assert_equal 400, last_response.status
  end

  def test_not_exist
    get '/not-exist'
    assert_equal 404, last_response.status
    assert_includes last_response.body, 'Not found'
  end
end
