require './server.rb'
require 'yaml'

quotes = YAML.load_file("Quotes.yaml")
quotes.each do |quote_data|
  begin
    quote = Quote.new(quote: quote_data["quote"], character: quote_data["character"])
    quote.save
    puts "Document inserted successfully."
  rescue Mongo::Error::OperationFailure => e
    puts "Insertion failed: #{e.message}"
  end
end