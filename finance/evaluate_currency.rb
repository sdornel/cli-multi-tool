require 'open-uri'
require 'json'
using ColorableString

module EvaluateCurrency
    extend self
    def retrieve_currency_values(currency)
        uri = URI.parse("https://v6.exchangerate-api.com/v6/4b2a0b71e549a4ef6429c4ec/latest/#{currency}")
        currency_hash = {}
        URI.open(uri) do |response|
            data = JSON.parse(response.read)
            currency_hash['base_code'] = data['base_code']
            currency_hash['conversion_rates'] = data['conversion_rates']
        end

        puts "\n=== Currency Data Retrieved Successfully ===".fg_color(:green)
        puts "Base Currency: #{currency_hash['base_code']}".fg_color(:gold)
    
        puts "\n=== Conversion Rates ===".fg_color(:cyan)
        currency_hash['conversion_rates'].each do |currency, rate|
          puts "  #{currency}: #{rate}".fg_color(:light_blue)
        end    
    end
end