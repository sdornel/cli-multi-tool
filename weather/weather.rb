require 'open-uri'
require 'json'
require 'time'
using ColorableString

module Weather
    extend self
    def get_location_from_ip
        uri = URI.parse('http://ip-api.com/json/') # 45 requests per minute as of 30/12/2024
        URI.open(uri) do |response|
            data = JSON.parse(response.read)
            { lat: data['lat'], lon: data['lon'] }
        end
    end

    def get_custom_location(city)
        uri = URI.parse("https://geocoding-api.open-meteo.com/v1/search?name=#{URI.encode_www_form_component(city)}&count=10&language=en&format=json")
        location_data = URI.open(uri) do |response|
            data = JSON.parse(response.read)
            puts data
            if data['results'] && !data['results'].empty?
                puts "Multiple locations found for '#{city}':".fg_color(:yellow)
                data['results'].each_with_index do |result, index|
                    puts "[#{index + 1}] #{result['name']}, #{result['admin1'] || 'N/A'}, #{result['country']}".fg_color(:cyan)
                end

                puts "These are the first (10 max) results returned from open-meteo".fg_color(:yellow)
                print "\nEnter the number of your chosen location: ".fg_color(:green)
                choice = $stdin.gets.chomp.to_i
                { lat: data['results'][0]['latitude'], lon: data['results'][0]['longitude'], city: data['results'][0]['name'] }
            else
                puts "City '#{city}' not found! open-meteo API might require a different string or the location may not be recognized.".fg_color(:red)
                exit
            end
        end
    end

    def display_weather_data(data, location)
        data[:hourly][:time].each_with_index do |time, index|
            formatted_time = Time.parse(time).strftime('%b %d, %H:%M')
            output = "| #{formatted_time.fg_color(:pink)} " \
                    "| 🌡️ Temp: " + "#{data[:hourly][:temperature_2m][index]}°C".fg_color(:green) + " " \
                    "| 🥶 Feels Like: " + "#{data[:hourly][:apparent_temperature][index]}°C".fg_color(:blue) + " " \
                    "| 💨 Wind: " + "#{data[:hourly][:wind_speed_10m][index]} km/h".fg_color(:cyan)
            
            if data[:hourly][:visibility][index] <= 1000
                output += " | 👀 Visibility: " + "#{data[:hourly][:visibility][index]}m".fg_color(:red)
            end
            puts output
        end
        puts "\nLatitude: #{location[:lat]}, Longitude: #{location[:lon]}".fg_color(:light_brown)
        puts "Current Time: #{Time.now} (#{Time.now.zone})".fg_color(:purple)
        puts "Elevation: #{data[:elevation]}".fg_color(:orange)
        print "Current Temperature: #{data[:current][:temperature_2m]}#{data[:current_units][:apparent_temperature]} ".fg_color(:green)
        puts "(Feels Like: #{data[:current][:apparent_temperature]}#{data[:current_units][:apparent_temperature]})".fg_color(:blue)
    end

    def get_weather_forecast_week(location = nil)
        location = location.nil? ? get_location_from_ip : get_custom_location(location)
        uri = URI("https://api.open-meteo.com/v1/forecast?latitude=#{location[:lat]}&longitude=#{location[:lon]}&current=temperature_2m,apparent_temperature&hourly=temperature_2m,apparent_temperature,visibility,wind_speed_10m&timezone=auto") # if error add &daily= back to end
        data = URI.open(uri) do |response|
            JSON.parse(response.read, symbolize_names: true)
        end
        puts "7 Day Weather Forecast Report".fg_color(:cyan)
        display_weather_data(data, location)
    end

    def get_weather_forecast_three(location = nil)
        location = location.nil? ? get_location_from_ip : get_custom_location(location)
        uri = URI("https://api.open-meteo.com/v1/forecast?latitude=#{location[:lat]}&longitude=#{location[:lon]}&current=temperature_2m,apparent_temperature&hourly=temperature_2m,apparent_temperature,visibility,wind_speed_10m&timezone=auto&forecast_days=3")
        data = URI.open(uri) do |response|
            JSON.parse(response.read, symbolize_names: true)
        end
        puts "3 Day Weather Forecast Report".fg_color(:cyan)
        display_weather_data(data, location)
    end

    def get_weather_forecast_day(location = nil)
        location = location.nil? ? get_location_from_ip : get_custom_location(location)
        uri = URI("https://api.open-meteo.com/v1/forecast?latitude=#{location[:lat]}&longitude=#{location[:lon]}&current=temperature_2m,apparent_temperature&hourly=temperature_2m,apparent_temperature,visibility,wind_speed_10m&timezone=auto&forecast_days=1")
        data = URI.open(uri) do |response|
            JSON.parse(response.read, symbolize_names: true)
        end
        puts "1 Day Weather Forecast Report".fg_color(:cyan)
        display_weather_data(data, location)
    end
end