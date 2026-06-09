# frozen_string_literal: true

require_relative 'admin_app'
require_relative 'api_app'
require 'rack/logger'
require 'logger'

Dir.mkdir('log') unless Dir.exist?('log')

class RequestLogger
  def initialize(app, log_file = 'log/requests.log')
    @app = app
    log = File.open(log_file, 'a')
    log.sync = true
    @logger = ::Logger.new(log)
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info("#{env['REQUEST_METHOD']} #{env['PATH_INFO']} #{status}")
    [status, headers, body]
  end
end

use Rack::Logger
use RequestLogger

map '/admin' do
  run AdminApp
end

map '/api' do
  run ApiApp
end
