# server.rb
require 'sinatra'
require "sinatra/namespace"
require 'mongoid'
require 'json'

# Load mongoid configuration, using MONGODB_URI env var for production if needed
if ENV['MONGODB_URI']
  Mongoid.configure do |config|
    config.clients.default.uri = ENV['MONGODB_URI']
    config.clients.default.options.auth_mech = :scram
    config.clients.default.options.server_selection_timeout = 5
  end
else
  Mongoid.load! "mongoid.yml"
end

class Quote
  include Mongoid::Document

  field :quote, type: String
  field :character, type: String

  validates :quote, presence: true
  validates :character, presence: true

  index({ character: 'text' })

  scope :character, -> (character, limit = nil) {
  query = where(character: /^#{character}/)
  limit ? query.limit(limit) : query
  }

end

get '/' do
  '🐭🌖 Dune Quotes  🐭🌖'
end

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  get '/quotes' do
    quotes = Quote.all

    if params[:character]
      quotes = quotes.where(character: /^#{params[:character]}/)
    end

    if params[:quote]
      quotes = quotes.where(quote: /^#{params[:quote]}/)
    end

    if params[:limit]
      limit = params[:limit].to_i
      quotes = quotes.limit(limit)
    end

    quotes.to_json
  end

  get '/quotes/id/:id' do |id|
    quote = Quote.where(id: id).first
    halt(404, { message:'Quote Not Found on Arrakis'}.to_json) unless quote
    quote.to_json
  end

  get '/quotes/random' do
    quote = Quote.collection().aggregate([{ '$sample' => { 'size' => 1 } }])
    quote.to_json
  end

end