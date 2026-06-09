# frozen_string_literal: true

require 'logger'
require 'fileutils'
require_relative 'admin_app'
require_relative 'api_app'

FileUtils.mkdir_p('log') unless File.directory?('log')

log_file = File.open('log/requests.log', 'a+')
log_file.sync = true

module Rack
  class Logger
    def initialize(app, logger = nil)
      @app = app
      @logger = logger || ::Logger.new($stderr)
    end

    def call(env)
      began_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      status, headers, body = @app.call(env)
      body = Rack::BodyProxy.new(body) { log(env, status, headers, began_at) }
      [status, headers, body]
    end

    private

    def log(env, status, headers, began_at)
      now = Time.now
      length = headers[Rack::CONTENT_LENGTH]
      length = '-' if length.nil? || length.to_s == '0'

      msg = format(
        '%<method>s %<path>s %<status>d',
        method: env['REQUEST_METHOD'],
        path: env['PATH_INFO'],
        status: status
      )

      if @logger.respond_to?(:info)
        @logger.info(msg)
      elsif @logger.respond_to?(:write)
        @logger.write("#{now.iso8601} #{msg}\n")
      else
        @logger << "#{now.iso8601} #{msg}\n"
      end
    end
  end
end

use Rack::Logger, log_file

map '/admin' do
  run AdminApp
end

map '/api' do
  run ApiApp
end

map '/' do
  run lambda { |env|
    [
      200,
      { 'Content-Type' => 'application/json' },
      [
        {
          message: 'Sinatra Multi-App Server',
          apps: {
            admin: '/admin',
            api: '/api'
          }
        }.to_json
      ]
    ]
  }
end