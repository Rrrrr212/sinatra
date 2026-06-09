require 'bundler/setup'
require 'fileutils'
require 'rack'
require_relative 'admin_app'
require_relative 'api_app'

log_directory = File.expand_path('log', __dir__)
FileUtils.mkdir_p(log_directory)
log_file = File.open(File.join(log_directory, 'requests.log'), 'a')
log_file.sync = true

class RequestStatusLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    env[Rack::RACK_LOGGER]&.info("#{env['REQUEST_METHOD']} #{env['PATH_INFO']} #{status}")
    [status, headers, body]
  rescue StandardError
    env[Rack::RACK_LOGGER]&.error("#{env['REQUEST_METHOD']} #{env['PATH_INFO']} 500")
    raise
  end
end

use Rack::Config do |env|
  env[Rack::RACK_ERRORS] = log_file
end

use Rack::Logger
use RequestStatusLogger

map '/admin' do
  run AdminApp
end

map '/api' do
  run ApiApp
end
