# server.rb
require 'sinatra'
require "sinatra/namespace"
require 'mongoid'
require 'json'

Mongoid.load! "mongoid.yml"

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

    [:quote, :character].each do |filter|
      quotes = quotes.send(filter => params[filter]) if params[filter]
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