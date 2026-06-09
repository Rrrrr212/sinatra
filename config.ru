require 'logger'
require_relative 'admin_app'
require_relative 'api_app'

log_file = File.new("requests.log", "a+")
log_file.sync = true

# 添加 Rack::Logger 中间件
use Rack::Logger, Logger::INFO

# 记录 HTTP 方法、路径和响应状态码到日志文件
use Rack::CommonLogger, log_file

map '/admin' do
  run AdminApp
end

map '/api' do
  run ApiApp
end
