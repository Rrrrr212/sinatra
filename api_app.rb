# frozen_string_literal: true

require 'sinatra/base'

class ApiApp < Sinatra::Base
  get '/' do
    'API Root'
  end

  get '/status' do
    'API Status OK'
  end
end
