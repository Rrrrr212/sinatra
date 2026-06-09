# frozen_string_literal: true

require 'sinatra/base'

class AdminApp < Sinatra::Base
  get '/' do
    'Admin Dashboard'
  end

  get '/users' do
    'Admin Users List'
  end
end
