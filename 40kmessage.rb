#!/usr/bin/env ruby
require 'bundler/setup'
Bundler.require

require_relative 'quotes/imperium'
require_relative 'quotes/mechanicus'
require_relative 'quotes/dark_mechanicum'
require_relative 'quotes/imperium'
require_relative 'quotes/ork'
require_relative 'helpers/imperial_date'
require_relative 'system_info/system_info'
require_relative 'git_scripts/list_repos'
require_relative 'scrapcode'

ALL_QUOTES = IMPERIUM_QUOTES + ADEPTUS_MECHANICUS_QUOTES + ORK_QUOTES + DARK_MECHANICUM_QUOTES

# imperorkium_quotes as the name?
if ARGV.include?('--help') || ARGV.include?('-help') || ARGV.include?('--h') || ARGV.include?('-h')
    puts 'Warhammer 40K Quotes CLI'
    puts 'Usage:'
    puts '  40kmessage                           # Show a transmission followed by a random quote'
    puts '  40kmessage --help || 40kmessage -h   # Display this help message'
    puts '  40kmessage -gs -sir                  # Display specific repos not updated in >= 1 year. List is in ListRepos module'
    puts '  40kmessage -gs -ir                   # Display all repos not updated in >= 1 year'
    puts '  40kmessage -gs -repos                # Display all repos not updated in >= 1 year'
    puts '  40kmessage -gs -prepos               # Display all repos not updated in >= 1 year'
    puts '  40kmessage -t -imp                   # Imperium quote'
    puts '  40kmessage -t -mec                   # Adeptus Mechanicus quote'
    puts '  40kmessage -t -ork                   # Ork quote'
    puts '  40kmessage -t -dme                   # Dark Mechanicum quote'
    puts '  40kmessage -t                        # Random 40k quote from list'
    puts '  40kmessage -power                    # Power Status Report'
    puts '  40kmessage -temp                     # Temperature Report'
    puts '  40kmessage -scrapcode                # Temperature Report'
    exit
end

if ARGV[0] == '-t' # t = thought for the day
    case ARGV[1]
    when '-imp'
        puts '+++ ' + IMPERIUM_QUOTES.sample + ' +++'
    when '-mec'
        puts '+++ ' + ADEPTUS_MECHANICUS_QUOTES.sample + ' +++'
    when '-ork'
        puts '+++ ' + ORK_QUOTES.sample + ' +++'
    when '-dme'
        puts '+++ ' + DARK_MECHANICUM_QUOTES.sample + ' +++'
    else
        puts '+++ THOUGHT FOR THE DAY: ' + ALL_QUOTES.sample + ' +++'
    end
else
    puts '+++ TRANSMISSION INBOUND +++'
    puts "+++ ORIGIN: SYSTEM MONITORING NODE PRIMUS-#{rand(1..10000000)} +++"
    puts '+++ AUTHORIZATION KEY: ████-███-SERPENS-███-ALPHA-███-OMEGA +++'
    puts "+++ RELAYING TRANSMISSION VIA: ASTROPATHIC DUCT ALPHA-PRIMUS-#{rand(1..10000000)} +++"
    puts ImperialDate.calculate_date()
    puts ImperialDate.time_stamp()
    puts '+++ RECIPIENT: ██ ██ ██ [REDACTED] +++'
    puts ''
    puts "---------------------------------------------------------------------"
    puts ''
    if ARGV[0] == '-power'
        SystemInfo.battery_level
    elsif ARGV[0] == '-temp'
        SystemInfo.temperature
    elsif ARGV[0] == '-gs'
        if ARGV[1] == '-sir'
            ListRepos.display_specific_inactive_repos
        elsif ARGV[1] == '-ir'
            ListRepos.display_inactive_repos
        elsif ARGV[1] == '-repos'
            ListRepos.display_all_repos
        elsif ARGV[1] == '-prepos'
            ListRepos.display_all_private_repos
        end

    elsif ARGV[0] == '-scrapcode'
        Scrapcode.scrapcode
    else
        '+++ INVALID CHOICE +++'
    end
    puts ''
    puts "---------------------------------------------------------------------"
    puts ''
    puts "+++ THOUGHT FOR THE DAY: #{ALL_QUOTES.sample} +++"
    puts '+++ TRANSMISSION TERMINATED +++'
end
