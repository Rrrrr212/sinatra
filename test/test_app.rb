require_relative 'test_helper'
require_relative '../app'

class AppTest < Minitest::Test
  def app
    Sinatra::Application
  end

  def test_hello_name
    get '/hello/world'
    assert_status 200
    assert_include last_response.body, "world"
  end

  def test_post_data_valid_json
    post '/data', '{"key": "value"}', { "CONTENT_TYPE" => "application/json" }
    assert_status 201
  end

  def test_post_data_invalid_json
    post '/data', 'invalid json', { "CONTENT_TYPE" => "application/json" }
    assert_status 400
  end

  def test_not_exist
    get '/not-exist'
    assert_status 404
    assert_include last_response.body, "Not found"
  end
end
