#!/usr/bin/env ruby
require 'bundler/setup'
Bundler.require

require 'dotenv'
Dotenv.load
GITHUB_TOKEN = ENV['GITHUB_TOKEN']
GITHUB_USERNAME = ENV['GITHUB_USERNAME']
EXCHANGERATE_KEY = ENV['EXCHANGERATE_KEY']
require_relative 'quotes/imperium'
require_relative 'quotes/mechanicus'
require_relative 'quotes/dark_mechanicum'
require_relative 'quotes/imperium'
require_relative 'quotes/ork'
require_relative 'scrapcode'
require_relative 'helpers/imperial_date'
require_relative 'system_info/system_info'
require_relative 'git_scripts/list_repos'
require_relative 'git_scripts/pull_request'
require_relative 'weather/weather'
require_relative 'finance/evaluate_currency'
require_relative 'rename_files/rename_files'

ALL_QUOTES = IMPERIUM_QUOTES + ADEPTUS_MECHANICUS_QUOTES + ORK_QUOTES + DARK_MECHANICUM_QUOTES

# imperorkium_quotes as the name?
if ARGV.include?('--help') || ARGV.include?('-help') || ARGV.include?('--h') || ARGV.include?('-h')
    puts 'Ruby Multi Tool CLI'
    puts 'Usage:'
    puts '  40kmessage                    # Show a transmission followed by a random quote'
    puts '  --help || -h                  # Display this help message'
    puts '  -gs -sir                      # Display specific repos not updated in >= 1 year. List is in ListRepos module'
    puts '  -gs -ir                       # Display all repos not updated in >= 1 year'
    puts '  -gs -repos                    # Display all repos'
    puts '  -gs -prepos                   # Display all private repos'
    puts '  -gs -pr -repo-owner repo-name # Display all pull requests for a repository'
    puts '  -weather7                     # Display weather info for your location (7 day forecast)'
    puts '  -weather3                     # Display weather info for your location (7 day forecast)'
    puts '  -weather                      # Display weather info for your location (current day)'
    puts '  -weather London               # Display weather info for chosen location. Many locations are not unique and you will be prompted to specify further'
    puts '  -weather3 London              # Display weather info for chosen location. Many locations are not unique and you will be prompted to specify further'
    puts '  -weather7 London              # Display weather info for chosen location. Many locations are not unique and you will be prompted to specify further'
    puts '  -temp                         # Temperature Report'
    puts '  -power                        # Power Status Report'
    puts '  -rename-files                 # Single/bulk renaming of files'
    puts '  -change-file-ext              # Changes file extension'
    puts '  40kmessage -t -imp            # Imperium quote'
    puts '  40kmessage -t -mec            # Adeptus Mechanicus quote'
    puts '  40kmessage -t -ork            # Ork quote'
    puts '  40kmessage -t -dme            # Dark Mechanicum quote'
    puts '  40kmessage -t                 # Random 40k quote from list'
    puts '  40kmessage -scrapcode         # Scrapcode thing that I should make more dynamic and random'
    exit
end

if ARGV[0] == '-t'
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
        elsif ARGV[1] == '-pr' # got complicated so just did the simple/fast one. maybe add more capability in future
            PullRequest.get_open_prs_by_repo_name(ARGV[2], ARGV[3])
        end
    elsif ARGV[0] == '-stocks'

    elsif ARGV[0] == '-crypto'

    elsif ARGV[0] == '-curr'
        # fetch and compare currency values
        if ARGV[1]
            EvaluateCurrency.retrieve_currency_values(ARGV[1])
        else
            EvaluateCurrency.retrieve_currency_values('USD')
        end
    elsif ARGV[0] == '-weather7'
        if ARGV[1] # means a city was included
            Weather.get_weather_forecast_week(ARGV[1])
        else
            Weather.get_weather_forecast_week
        end
    elsif ARGV[0] == '-weather3'
        if ARGV[1]
            Weather.get_weather_forecast_three(ARGV[1])
        else
            Weather.get_weather_forecast_three
        end
    elsif ARGV[0] == '-weather'
        if ARGV[1]
            Weather.get_weather_forecast_day(ARGV[1])
        else
            Weather.get_weather_forecast_day
        end
    # elsif mass rename files in a folder
    elsif ARGV[0] == '-news'
    # add bunch of categories for news
    elsif ARGV[0] == '-rename-files'
        RenameFile.change_filename_text
    elsif ARGV[0] == '-change-ext' # create way to change extension of specific files?
        RenameFile.change_file_ext    
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
