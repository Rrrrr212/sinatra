# frozen_string_literal: true

require 'sinatra/base'

class AdminApp < Sinatra::Base
  get '/' do
    content_type :json
    { app: 'AdminApp', message: 'Admin Dashboard' }.to_json
  end

  get '/users' do
    content_type :json
    { app: 'AdminApp', users: %w[alice bob charlie] }.to_json
  end

  get '/status' do
    content_type :json
    { app: 'AdminApp', status: 'healthy', uptime: Time.now.to_s }.to_json
  end
end