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
        puts "Latitude: #{location[:lat]}, Longitude: #{location[:lon]}"
        uri = URI("https://api.open-meteo.com/v1/forecast?latitude=#{location[:lat]}&longitude=#{location[:lon]}&current=apparent_temperature&hourly=temperature_2m,apparent_temperature,visibility,wind_speed_10m&timezone=auto&daily=")
        res = Net::HTTP.get_response(uri)
        puts res.body if res.is_a?(Net::HTTPSuccess)
        data = JSON.parse(res.body, symbolize_names: true)
        puts "Current Time: #{Time.now} (#{Time.now.zone})"
        puts "Elevation: #{data[:elevation]}"
        puts "Current Temperature: #{data[:current][:apparent_temperature]}#{data[:current_units][:apparent_temperature]}"
        puts "Forecast for the days: "
        
        data[:daily][:time].each_with_index do |time, index|
            if index == data[:daily][:time].last
                print "#{time}"
            else
                print "#{time}, "
            end
        end
        data[:hourly][:time].each_with_index do |time, index|
            formatted_time = Time.parse(time).strftime('%b %d, %H:%M')
            if data[:hourly][:visibility][index] <= 1000
                puts "| 🕒 #{formatted_time} " \
                        "| 🌡️ Temp: #{data[:hourly][:temperature_2m][index]}°C " \
                        "| 🥶 Feels Like: #{data[:hourly][:apparent_temperature][index]}°C " \
                        "| 👀 Visibility: #{data[:hourly][:visibility][index]}m " \
                        "| 💨 Wind: #{data[:hourly][:wind_speed_10m][index]} km/h |"
            else
                puts "| 🕒 #{formatted_time} " \
                        "| 🌡️ Temp: #{data[:hourly][:temperature_2m][index]}°C " \
                        "| 🥶 Feels Like: #{data[:hourly][:apparent_temperature][index]}°C " \
                        "| 💨 Wind: #{data[:hourly][:wind_speed_10m][index]} km/h |"
            end
        end
    end
end