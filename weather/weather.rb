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
        # get custom location
        uri = URI.parse("https://geocoding-api.open-meteo.com/v1/search?name=#{URI.encode_www_form_component(city)}&count=1&language=en&format=json")
        uri
    end

    def get_weather_forecast
        location = get_location_from_ip
        uri = URI("https://api.open-meteo.com/v1/forecast?latitude=#{location[:lat]}&longitude=#{location[:lon]}&current=temperature_2m,apparent_temperature&hourly=temperature_2m,apparent_temperature,visibility,wind_speed_10m&timezone=auto&daily=")
        data = URI.open(uri) do |response|
            JSON.parse(response.read, symbolize_names: true)
        end

        puts "7 Day Weather Forecast Report".fg_color(:cyan)
        data[:hourly][:time].each_with_index do |time, index|
            formatted_time = Time.parse(time).strftime('%b %d, %H:%M')
            output = "| #{formatted_time.fg_color(:purple)} " \
                    "| 🌡️ Temp: " + "#{data[:hourly][:temperature_2m][index]}°C".fg_color(:green) + " " \
                    "| 🥶 Feels Like: " + "#{data[:hourly][:apparent_temperature][index]}°C".fg_color(:blue) + " " \
                    "| 💨 Wind: " + "#{data[:hourly][:wind_speed_10m][index]} km/h".fg_color(:cyan)
            
            if data[:hourly][:visibility][index] <= 1000
                output += " | 👀 Visibility: " + "#{data[:hourly][:visibility][index]}m".fg_color(:red)
            end
            puts output
        end
        puts ''
        puts "Latitude: #{location[:lat]}, Longitude: #{location[:lon]}".fg_color(:light_brown)
        puts "Current Time: #{Time.now} (#{Time.now.zone})".fg_color(:purple)
        puts "Elevation: #{data[:elevation]}".fg_color(:orange)
        print "Current Temperature: #{data[:current][:temperature_2m]}#{data[:current_units][:apparent_temperature]} ".fg_color(:green)
        puts "(Feels Like: #{data[:current][:apparent_temperature]}#{data[:current_units][:apparent_temperature]})".fg_color(:blue)
    end
end