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

get '/logs' do
  content_type :html
  <<-HTML
<!DOCTYPE html>
<html>
<head>
  <title>Log Viewer</title>
</head>
<body>
  <h1>Server Time Log</h1>
  <div id="logs"></div>
  <script>
    const evtSource = new EventSource('/logs/stream');
    const logsDiv = document.getElementById('logs');
    evtSource.onmessage = function(e) {
      const data = JSON.parse(e.data);
      const p = document.createElement('p');
      p.textContent = data.time;
      logsDiv.appendChild(p);
    };
  </script>
</body>
</html>
  HTML
end

get '/logs/stream' do
  content_type 'text/event-stream'
  cache_control 'no-cache'
  stream(:keep_open) do |out|
    while !out.closed?
      current_time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      out << "data: {\"time\":\"#{current_time}\"}\n\n"
      sleep 1
    end
  end
end

$stderr.puts "starting"
