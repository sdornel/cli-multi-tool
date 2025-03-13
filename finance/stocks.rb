require 'open-uri'
require 'json'
using ColorableString

module Stocks
    extend self

    STOCKS = [
        "AAPL",  # Apple
        "MSFT",  # Microsoft
        "GOOGL", # Alphabet
        "AMZN",  # Amazon
        "META",  # Meta (Facebook)
        "TSLA",  # Tesla
        "NVDA",  # Nvidia
        "JPM",   # JPMorgan Chase
        "BRK.B", # Berkshire Hathaway
        "V",     # Visa
        "SPY",   # S&P 500 ETF
        "QQQ",   # Nasdaq-100 ETF
        "DIA"    # Dow Jones ETF (newly added)
    ]

    def from_list_retrieve_stock_data
        STOCKS.each do |stock|
            uri = URI.parse("https://finnhub.io/api/v1/quote?symbol=#{URI.encode_www_form_component(stock)}&token=#{FINNHUB_KEY}")
            begin
                URI.open(uri) do |response|
                    data = JSON.parse(response.read)
                    display_stock_data(stock, data)
                end
                # sleep 0.3  # avoid rate limiting
            rescue => e
                puts "⚠️ Failed to fetch data for #{stock}: #{e.message}".fg_color(:red)
            end
        end
    end

    def display_stock_data(symbol, data)
        change_color = data['d'].to_f >= 0 ? :green : :red

        puts "\n📊 #{symbol}".fg_color(:cyan)
      
        puts "  #{'Current:'.ljust(12)} $#{data['c']}".fg_color(:light_blue)
        puts "  #{'Change:'.ljust(12)} $#{data['d']} (#{data['dp']}%)".fg_color(change_color)
      
        puts "  #{'Open:'.ljust(12)} $#{data['o']}".fg_color(:gold) +
             " | #{'High:'.ljust(6)} $#{data['h']}".fg_color(:green) +
             " | #{'Low:'.ljust(5)} $#{data['l']}".fg_color(:red)
      
        puts "  #{'Prev Close:'.ljust(12)} $#{data['pc']}".fg_color(:pink)
    end
end