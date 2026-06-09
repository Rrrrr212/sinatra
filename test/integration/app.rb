$stderr.puts "loading"
require 'sinatra'

class Article
  @@articles = {}

  def initialize(id, title = nil, body = nil)
    @id = id
    @title = title
    @body = body
  end

  attr_accessor :id, :title, :body

  def self.find(id)
    @@articles[id]
  end

  def self.create(id, title = nil, body = nil)
    @@articles[id] = new(id, title, body)
  end

  def self.clear
    @@articles = {}
  end

  def update(attributes)
    @title = attributes[:title] if attributes.key?(:title)
    @body = attributes[:body] if attributes.key?(:body)
    self
  end

  def destroy
    @@articles.delete(@id)
  end

  def as_json
    { id: @id, title: @title, body: @body }
  end
end

configure do
  set :foo, :bar
end

before '/articles/:id' do
  @article = Article.find(params[:id])
  halt 404, 'Article not found' unless @article
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

get '/articles' do
  content_type :json
  Article.class_variable_get(:@@articles).values.map(&:as_json).to_json
end

post '/articles' do
  id = params[:id] || (Article.class_variable_get(:@@articles).keys.map(&:to_i).max.to_i + 1).to_s
  Article.create(id, params[:title], params[:body])
  status 201
  content_type :json
  @article = Article.find(id)
  @article.as_json.to_json
end

get '/articles/:id' do
  content_type :json
  @article.as_json.to_json
end

put '/articles/:id' do
  @article.update(title: params[:title], body: params[:body])
  content_type :json
  @article.as_json.to_json
end

delete '/articles/:id' do
  @article.destroy
  status 204
  ''
end

$stderr.puts "starting"
