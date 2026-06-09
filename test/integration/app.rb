$stderr.puts "loading"
require 'sinatra'

configure do
  set :foo, :bar
end

get '/app_file' do
  content_type :txt
  settings.app_file
end

get '/ping' do
  'pong'
end

get '/stream' do
  stream do |out|
    sleep 0.1
    out << "a"
    sleep 1.25
    out << "b"
  end
end

get '/mainonly' do
  object = Object.new
  begin
    object.send(:get, '/foo') { }
    'false'
  rescue NameError
    'true'
  end
end

set :out, nil
get '/async' do
  stream(:keep_open) { |o| (settings.out = o) << "hi!"; sleep 1 }
end

get '/send' do
  settings.out << params[:msg] if params[:msg]
  settings.out.close if params[:close]
  "ok"
end

get '/send_file' do
  file = File.expand_path '../views/a/in_a.str', __dir__
  send_file file
end

get '/streaming' do
  headers['Content-Length'] = '46'
  stream do |out|
    out << "It's gonna be legen -\n"
    sleep 0.5
    out << " (wait for it) \n"
    puts headers
    sleep 1
    out << "- dary!\n"
  end
end

class Subclass < Sinatra::Base
  set :out, nil
  get '/subclass/async' do
    stream(:keep_open) { |o| (settings.out = o) << "hi!"; sleep 1 }
  end

  get '/subclass/send' do
    settings.out << params[:msg] if params[:msg]
    settings.out.close if params[:close]
    "ok"
  end
end

use Subclass

MAX_FILE_SIZE = 10 * 1024 * 1024

post '/upload' do
  unless params[:file] && params[:file][:tempfile] && params[:file][:filename]
    halt 400, "No file provided"
  end

  file = params[:file]
  tempfile = file[:tempfile]
  filename = file[:filename]

  tempfile.seek(0, IO::SEEK_END)
  file_size = tempfile.tell
  tempfile.rewind

  if file_size > MAX_FILE_SIZE
    halt 400, "File size exceeds 10MB limit"
  end

  upload_dir = File.join(__dir__, '..', '..', 'uploads')
  FileUtils.mkdir_p(upload_dir) unless Dir.exist?(upload_dir)

  destination = File.join(upload_dir, filename)
  FileUtils.cp(tempfile.path, destination)

  "File '#{filename}' uploaded successfully (#{file_size} bytes)"
end

get '/download/:filename' do
  filename = params[:filename]
  upload_dir = File.join(__dir__, '..', '..', 'uploads')
  filepath = File.join(upload_dir, filename)

  unless File.exist?(filepath)
    halt 404, "File not found"
  end

  content_type :binary
  attachment filename
  send_file filepath
end

$stderr.puts "starting"
