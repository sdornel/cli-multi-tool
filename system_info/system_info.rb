require_relative '../helpers/colorable_string/colorable_string'
using ColorableString

module SystemInfo
    def self.battery_level
        command = 'upower -i $(upower -e)'
        output = `#{command}`
    
        if output.empty?
          puts 'Power information not available.'.fg_color(:red)
        else
            puts 'Power Status Report:'.fg_color(:cyan)
            puts 'via - upower -i $(upower -e)'.fg_color(:yellow)
            puts output.fg_color(:green)
        end
    end

    def self.temperature
        command = 'sensors' # could be more efficient but this will help me learn the commands
        output = `#{command}`
    
        if output.empty?
          puts 'Temperature information not available.'.fg_color(:red)
        else
          puts 'Temperature Report:'.fg_color(:cyan)
          puts 'via sensors'.fg_color(:yellow)
          puts output.fg_color(:green)
        end
    end
end