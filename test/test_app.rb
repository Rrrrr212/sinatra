require_relative 'test_helper'
require_relative '../app'

class TestAppTest < Minitest::Test
  def app
    Sinatra::Application
  end

  it 'returns a personalized greeting for GET /hello/:name' do
    get '/hello/world'

    assert last_response.ok?
    assert_include last_response.body, 'world'
  end

  it 'returns 201 for valid JSON on POST /data' do
    post '/data', JSON.dump(name: 'world'), { 'CONTENT_TYPE' => 'application/json' }

    assert_equal 201, last_response.status
  end

  it 'returns 400 for invalid JSON on POST /data' do
    post '/data', '{"name":', { 'CONTENT_TYPE' => 'application/json' }

    assert_equal 400, last_response.status
  end

  it 'returns the custom 404 page for unknown routes' do
    get '/not-exist'

    assert_equal 404, last_response.status
    assert_include last_response.body, 'Not found'
  end
end
