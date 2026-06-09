# frozen_string_literal: true

require 'sinatra'

class Article
  def self.find(id)
    find_by_id(id)
  end
end

before '/articles/:id' do
  @article = Article.find(params[:id])
  halt 404, 'Article not found' unless @article
end

get '/articles' do
  'Listing all articles'
end

post '/articles' do
  'Creating a new article'
end

get '/articles/:id' do
  "Showing article #{@article.id}"
end

put '/articles/:id' do
  "Updating article #{@article.id}"
end

delete '/articles/:id' do
  "Deleting article #{@article.id}"
end
