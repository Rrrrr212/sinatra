require_relative 'test_helper'
require_relative '../app'

class AppTest < Minitest::Test
  def app
    App
  end

  describe 'GET /hello/:name' do
    it 'returns a greeting that includes the given name' do
      get '/hello/world'
      assert ok?
      assert_include body, 'world'
    end

    it 'greets a different name correctly' do
      get '/hello/sinatra'
      assert ok?
      assert_include body, 'sinatra'
    end
  end

  describe 'POST /data' do
    it 'returns 201 when given valid JSON' do
      post '/data', { 'key' => 'value' }.to_json, 'CONTENT_TYPE' => 'application/json'
      assert_equal 201, status
    end

    it 'returns 400 when given invalid JSON' do
      post '/data', '{not-valid-json', 'CONTENT_TYPE' => 'application/json'
      assert_equal 400, status
    end
  end

  describe 'GET /not-exist' do
    it 'returns 404 with a Not found body for unknown routes' do
      get '/not-exist'
      assert_equal 404, status
      assert_include body, 'Not found'
    end
  end
end
