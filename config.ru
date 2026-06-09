require 'rack'
require 'rack/logger'
require_relative 'admin_app'
require_relative 'api_app'

log_path = File.expand_path('log/app.log', __dir__)
FileUtils.mkdir_p(File.dirname(log_path))
log_file = File.open(log_path, 'a')
log_file.sync = true

use Rack::Logger, nil, log_file

class RequestLoggingMiddleware
  def initialize(app, logger)
    @app = app
    @logger = logger
  end

  def call(env)
    method = env['REQUEST_METHOD']
    path = env['PATH_INFO']
    status, headers, body = @app.call(env)
    @logger.info "#{method} #{path} - #{status}"
    [status, headers, body]
  end
end

use RequestLoggingMiddleware, Logger.new(log_file)

map '/admin' do
  run AdminApp.new
end

map '/api' do
  run ApiApp.new
end
