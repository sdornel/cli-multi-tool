module Weather
    def self.get_location_from_ip
        uri = URI('http://ip-api.com/json/') # 45 requests per minute as of 30/12/2024
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        { lat: data['lat'], lon: data['lon'] }
    end

    def self.get_weather_forecast
        location = get_location_from_ip
        puts "Latitude: #{location[:lat]}, Longitude: #{location[:lon]}"

        uri = URI("https://api.open-meteo.com/v1/forecast?latitude=#{location[:lat]}&longitude=#{location[:lon]}&current=apparent_temperature&hourly=temperature_2m,apparent_temperature,visibility,wind_speed_10m&daily=")
        res = Net::HTTP.get_response(uri)
        puts res.body if res.is_a?(Net::HTTPSuccess)
        data = JSON.parse(res.body, symbolize_names: true)
        puts "Timezone: #{data[:timezone]}"
        puts "Elevation: #{data[:elevation]}"
    end
end