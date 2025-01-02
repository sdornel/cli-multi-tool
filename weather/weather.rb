require 'open-uri'
require 'json'
require 'time'

module Weather
    def self.get_location_from_ip
        uri = URI.parse('http://ip-api.com/json/') # 45 requests per minute as of 30/12/2024
        URI.open(uri) do |response|
            data = JSON.parse(response.read)
            { lat: data['lat'], lon: data['lon'] }
        end
    end

    def self.get_weather_forecast
        location = get_location_from_ip
        uri = URI("https://api.open-meteo.com/v1/forecast?latitude=#{location[:lat]}&longitude=#{location[:lon]}&current=temperature_2m,apparent_temperature&hourly=temperature_2m,apparent_temperature,visibility,wind_speed_10m&timezone=auto&daily=")
        res = Net::HTTP.get_response(uri)
        data = JSON.parse(res.body, symbolize_names: true)

        puts "7 Day Weather Forecast Report"
        data[:hourly][:time].each_with_index do |time, index|
            formatted_time = Time.parse(time).strftime('%b %d, %H:%M')
            if data[:hourly][:visibility][index] <= 1000
                puts "| 🕒 #{formatted_time} " \
                        "| 🌡️ Temp: #{data[:hourly][:temperature_2m][index]}°C " \
                        "| 🥶 Feels Like: #{data[:hourly][:apparent_temperature][index]}°C " \
                        "| 💨 Wind: #{data[:hourly][:wind_speed_10m][index]} km/h" \
                        "| 👀 Visibility: #{data[:hourly][:visibility][index]}m |"
            else
                puts "| 🕒 #{formatted_time} " \
                        "| 🌡️ Temp: #{data[:hourly][:temperature_2m][index]}°C " \
                        "| 🥶 Feels Like: #{data[:hourly][:apparent_temperature][index]}°C " \
                        "| 💨 Wind: #{data[:hourly][:wind_speed_10m][index]} km/h |"
            end
        end
        puts ''
        puts "Latitude: #{location[:lat]}, Longitude: #{location[:lon]}"
        puts "Current Time: #{Time.now} (#{Time.now.zone})"
        puts "Elevation: #{data[:elevation]}"
        puts "Current Temperature: #{data[:current][:temperature_2m]}#{data[:current_units][:apparent_temperature]}"
        puts "Feels Like: #{data[:current][:apparent_temperature]}#{data[:current_units][:apparent_temperature]}"
    end
end