require 'rack'
require 'logger'

app = proc do |env|
  env['rack.logger'].info "Something"
  [200, {'Content-Type' => 'text/plain'}, ["Hello"]]
end

builder = Rack::Builder.new do
  use Rack::Logger
  run app
end

puts "Done"
