require 'open-uri'
require 'json'
using ColorableString

module Stocks
    extend self

    STOCKS = {
        # Tech
        "AAPL"   => "Apple",
        "MSFT"   => "Microsoft",
        "GOOGL"  => "Alphabet (Google)",
        "AMZN"   => "Amazon",
        "META"   => "Meta (Facebook)",
        "TSLA"   => "Tesla",
        "NVDA"   => "Nvidia",
      
        # Financials
        "JPM"    => "JPMorgan Chase",
        "BRK.B"  => "Berkshire Hathaway",
        "V"      => "Visa",
        "MA"     => "Mastercard",
        "BAC"    => "Bank of America",
      
        # Consumer Goods & Retail
        "PG"     => "Procter & Gamble",
        "KO"     => "Coca-Cola",
        "WMT"    => "Walmart",
        "HD"     => "Home Depot",
        "MCD"    => "McDonald's",
        "NKE"    => "Nike",
        "COST"   => "Costco",
      
        # Healthcare
        "JNJ"    => "Johnson & Johnson",
        "PFE"    => "Pfizer",
        "UNH"    => "UnitedHealth Group",
      
        # Industrials
        "CAT"    => "Caterpillar",
        "GE"     => "General Electric",
        "MMM"    => "3M",
        "UPS"    => "UPS",
        "FDX"    => "FedEx",
      
        # Energy
        "XOM"    => "ExxonMobil",
        "CVX"    => "Chevron",
        "SLB"    => "Schlumberger",
      
        # Utilities
        "NEE"    => "NextEra Energy",
        "DUK"    => "Duke Energy",
      
        # ETFs (Indexes)
        "SPY"    => "S&P 500 ETF",
        "QQQ"    => "Nasdaq-100 ETF",
        "DIA"    => "Dow Jones ETF",
        "IWM"    => "Russell 2000 ETF",
        "XLF"    => "Financials Sector ETF",
        "XLK"    => "Tech Sector ETF",
        "XLE"    => "Energy Sector ETF",
        "XLV"    => "Healthcare Sector ETF"
    }

    def from_list_retrieve_stock_data
        STOCKS.each do |symbol, name|
            uri = URI.parse("https://finnhub.io/api/v1/quote?symbol=#{URI.encode_www_form_component(symbol)}&token=#{FINNHUB_KEY}")
            begin
                URI.open(uri) do |response|
                    data = JSON.parse(response.read)
                    display_stock_data(symbol, name, data)
                end
            rescue => e
                puts "⚠️ Failed to fetch data for #{name} (#{symbol}): #{e.message}".fg_color(:red)
            end
        end
    end

    def display_stock_data(symbol, name, data)
        change_color = data['d'].to_f >= 0 ? :green : :red

        puts "\n📊 #{symbol} – #{name}".fg_color(:cyan)
      
        puts "  #{'Current:'.ljust(12)} $#{data['c']}".fg_color(:light_blue)
        puts "  #{'Change:'.ljust(12)} $#{data['d']} (#{data['dp']}%)".fg_color(change_color)
      
        puts "  #{'Open:'.ljust(12)} $#{data['o']}".fg_color(:gold) +
             " | #{'High:'.ljust(6)} $#{data['h']}".fg_color(:green) +
             " | #{'Low:'.ljust(5)} $#{data['l']}".fg_color(:red)
      
        puts "  #{'Prev Close:'.ljust(12)} $#{data['pc']}".fg_color(:pink)
    end
end