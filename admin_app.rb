require 'sinatra/base'

class AdminApp < Sinatra::Base
  get '/' do
    'AdminApp home'
  end
end
