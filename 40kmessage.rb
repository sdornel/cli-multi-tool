#!/usr/bin/env ruby

require_relative 'quotes/imperium'
require_relative 'quotes/mechanicus'
require_relative 'quotes/dark_mechanicum'
require_relative 'quotes/imperium'
require_relative 'quotes/ork'
require_relative 'helpers/imperial_date'

ALL_QUOTES = IMPERIUM_QUOTES + ADEPTUS_MECHANICUS_QUOTES + ORK_QUOTES + DARK_MECHANICUM_QUOTES

# imperorkium_quotes as the name?
if ARGV.include?('--help') || ARGV.include?('-h')
    puts "Warhammer 40K Quotes CLI"
    puts "Usage:"
    puts "  40kmessage                           # Show a transmission followed by a random quote"
    puts "  40kmessage --help || 40kmessage -h   # Display this help message"
    puts "  40kmessage --imperium                # Imperium quote"
    puts "  40kmessage --mechanicus              # Adeptus Mechanicus quote"
    puts "  40kmessage --ork                     # Ork quote"
    puts "  40kmessage --dark-mechanicum         # Dark Mechanicum quote"
    exit
end

if ARGV.include?('--imperium')
    puts IMPERIUM_QUOTES.sample
elsif ARGV.include?('--mechanicus')
    puts ADEPTUS_MECHANICUS_QUOTES.sample
elsif ARGV.include?('--ork')
    puts ORK_QUOTES.sample
elsif ARGV.include?('--dark-mechanicum')
    puts DARK_MECHANICUM_QUOTES.sample
else
    puts "+++ TRANSMISSION INBOUND +++"
    puts "+++ ORIGIN: SYSTEM MONITORING NODE PRIMUS-#{rand(1..100000000)} +++"
    puts "+++ AUTHORIZATION KEY: ████-███-SERPENS-███-ALPHA-███-OMEGA +++"

    puts ImperialDate.calculate_date()
    puts ImperialDate.time_stamp()
    puts "+++ RECIPIENT: ██ ██ ██ [REDACTED] +++"
    puts ""

    puts ""
    puts "RELAYING TRANSMISSION VIA: ASTROPATHIC DUCT ALPHA-PRIMUS-#{rand(1..100000000)}"
    puts "+++ #{ALL_QUOTES.sample} +++"
    puts "+++ TRANSMISSION TERMINATED +++"

end
