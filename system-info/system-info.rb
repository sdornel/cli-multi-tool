module SystemInfo
    def self.battery_level
        command = "upower -i $(upower -e)"
        output = `#{command}`.strip
    
        if output.empty?
        puts '>>> Power information not available.'
        return nil
        else
        puts '>>> Power Status Report:'
        puts '>>> via - upower -i $(upower -e)'
        puts "#{output}"
        return output
        end
    end
end