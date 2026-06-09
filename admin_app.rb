require 'sinatra/base'

class AdminApp < Sinatra::Base
  get '/' do
    'Admin App'
  end
end
