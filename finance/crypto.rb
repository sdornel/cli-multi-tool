require 'open-uri'
require 'json'
using ColorableString

module Crypto
    extend self

    COINS = {
        "bitcoin"        => "Bitcoin",
        "ethereum"       => "Ethereum",
        "tether"         => "Tether (USDT)",
        "binancecoin"    => "BNB",
        "solana"         => "Solana",
        "chainlink"      => "Chainlink (LINK)",
        "litecoin"       => "Litecoin (LTC)",
        "usd-coin"       => "USD Coin (USDC)",
        "cardano"        => "Cardano",
        "dogecoin"       => "Dogecoin",
        "avalanche-2"    => "Avalanche",
        "shiba-inu"      => "Shiba Inu",
        "stellar"        => "Stellar (XLM)"
    }



    def retrieve_specific_crypto_data(coin)
        formatted_coin = coin[1..].downcase
        url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=#{formatted_coin}&order=market_cap_desc&per_page=100&page=1&sparkline=false"

        begin
            response = URI.open(url)
            data = JSON.parse(response.read)
            puts "\n💰 Crypto Price (USD):\n".fg_color(:cyan)
            data.each do |coin|
                symbol = coin['symbol'].upcase
                name = COINS[coin['id']] || coin['name']
                current = coin['current_price']
                all_time_high = coin['ath']
                high = coin['high_24h']
                low = coin['low_24h']
                change = coin['price_change_24h']
                change_pct = coin['price_change_percentage_24h']
                volume = coin['total_volume']
                market_cap = coin['market_cap']

                change_color = change.to_f >= 0 ? :light_green : :light_red

                puts "#{symbol.ljust(5)} – #{name}".fg_color(:cyan)

                print "  Price: $#{current}  ".fg_color(:light_blue)
                print "Change: #{change >= 0 ? '+' : ''}#{change.round(2)} (#{change_pct.round(2)}%)  ".fg_color(change_color)
                puts "High: $#{high} | Low: $#{low}".fg_color(:gold)
                
                puts "  Market Cap: $#{market_cap}  |  Volume (24h): $#{volume}".fg_color(:light_yellow)
            end
        rescue => e
            puts "❌ Failed to fetch crypto price: #{e.message}".fg_color(:red)
        end
    end

    def from_list_retrieve_crypto_data
        ids = COINS.keys.join(',');
        url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=#{ids}&order=market_cap_desc&per_page=100&page=1&sparkline=false"

        begin
            response = URI.open(url)
            data = JSON.parse(response.read)
            puts "\n💰 Crypto Prices (USD):\n".fg_color(:cyan)
            data.each do |coin|
                symbol = coin['symbol'].upcase
                name = COINS[coin['id']] || coin['name']
                current = coin['current_price']
                all_time_high = coin['ath']
                high = coin['high_24h']
                low = coin['low_24h']
                change = coin['price_change_24h']
                change_pct = coin['price_change_percentage_24h']
                volume = coin['total_volume']
                market_cap = coin['market_cap']

                change_color = change.to_f >= 0 ? :light_green : :light_red

                puts "#{symbol.ljust(5)} – #{name}".fg_color(:cyan)

                print "  Price: $#{current}  ".fg_color(:light_blue)
                print "Change: #{change >= 0 ? '+' : ''}#{change.round(2)} (#{change_pct.round(2)}%)  ".fg_color(change_color)
                puts "High: $#{high} | Low: $#{low}".fg_color(:gold)
                
                puts "  Market Cap: $#{market_cap}  |  Volume (24h): $#{volume}".fg_color(:light_yellow)
                puts ""
            end
        rescue => e
            puts "❌ Failed to fetch crypto prices: #{e.message}".fg_color(:red)
        end
    end
end