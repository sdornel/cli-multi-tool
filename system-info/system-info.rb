module SystemInfo
    def self.battery_level
        command = "upower -i $(upower -e | grep BAT) | grep 'percentage' | awk '{print $2}'"
        level = `#{command}`.strip
    
        if level.empty?
        puts ">>> Battery information not available."
        return nil
        else
        puts ">>> Laptop Battery Level: #{level}"
        return level
        end
    end
end