require 'sinatra'
require 'fileutils'

MAX_UPLOAD_SIZE = 10 * 1024 * 1024
UPLOADS_DIR = File.expand_path('./uploads', __dir__)
FileUtils.mkdir_p(UPLOADS_DIR)

get '/' do
  'Hello, Sinatra!'
end

post '/echo' do
  request.body.read.to_s
end

post '/upload' do
  file = params[:file]

  unless file && file.respond_to?(:tempfile) && file.respond_to?(:filename)
    status 400
    return 'Missing or invalid file parameter'
  end

  filename = File.basename(file[:filename].to_s)
  if filename.empty? || filename == '.' || filename == '..'
    status 400
    return 'Invalid filename'
  end

  size = file[:tempfile].size
  if size > MAX_UPLOAD_SIZE
    status 400
    return "File too large (max #{MAX_UPLOAD_SIZE / (1024 * 1024)}MB)"
  end

  dest_path = File.join(UPLOADS_DIR, filename)
  FileUtils.cp(file[:tempfile].path, dest_path)

  "Uploaded #{filename} (#{size} bytes)"
end

get '/download/:filename' do
  filename = File.basename(params[:filename])
  file_path = File.join(UPLOADS_DIR, filename)

  unless File.exist?(file_path) && File.file?(file_path)
    status 404
    return 'File not found'
  end

  send_file file_path, disposition: :attachment, filename: filename
end
