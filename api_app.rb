# frozen_string_literal: true

require 'sinatra/base'

class ApiApp < Sinatra::Base
  before do
    content_type :json
  end

  get '/' do
    { app: 'ApiApp', message: 'API is running' }.to_json
  end

  get '/data' do
    { app: 'ApiApp', data: [1, 2, 3, 4, 5] }.to_json
  end

  get '/health' do
    { app: 'ApiApp', status: 'ok' }.to_json
  end
end