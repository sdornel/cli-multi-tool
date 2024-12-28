module SystemInfo
    def self.battery_level
        command = "upower -i $(upower -e)"
        output = `#{command}`
    
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

    def self.temperature
        command = "sensors" # could be more efficient but this will help me learn the commands
        output = `#{command}`
    
        if output.empty?
          puts ">>> Temperature information not available."
          return nil
        else
          puts ">>> Temperature Report:"
          puts ">>> via sensors"
          puts output
          return output
        end
    end
end