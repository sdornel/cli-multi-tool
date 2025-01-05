module ImperialDate
  extend self
  def calculate_date(real_year = Time.now.year)
      year_in_millennium = real_year % 1000
      millennium = (real_year / 1000) + 1
      "+++ DATE: #{year_in_millennium}.M#{millennium} +++"
    end
  
    def time_stamp
      "+++ TIME STAMP: #{Time.now.strftime("%H:%M STANDARD TERRAN HOURS")} +++"
    end
end