
# def imperial_date
#     current_year = Time.now.year
#     year_in_millennium = current_year % 1000
#     millennium = (current_year / 1000) + 1
    
#     "+++ DATE: #{year_in_millennium}.M#{millennium} +++"
# end

class ImperialDate
    # def self.to_s(real_year = Time.now.year)
    #   year_in_millennium = real_year % 1000
    #   millennium = (real_year / 1000) + 1
    #   "+++ DATE: #{year_in_millennium}.M#{millennium} +++"
    # end
  
    # def self.time_stamp
    #   "+++ TIME STAMP: #{Time.now.strftime("%H:%M STANDARD TERRAN HOURS")} +++"
    # end

    def self.calculate_date(real_year = Time.now.year)
        year_in_millennium = real_year % 1000
        millennium = (real_year / 1000) + 1
        "+++ DATE: #{year_in_millennium}.M#{millennium} +++"
      end
    
      def self.time_stamp
        "+++ TIME STAMP: #{Time.now.strftime("%H:%M STANDARD TERRAN HOURS")} +++"
      end
end