class Holidays
  def self.next_three(country)
    total_holiday_list = NagerService.holidays(country)
    upcoming_holidays = []
    total_holiday_list.each do |holiday|
      if Date.parse(holiday['date']) > Date.today
        upcoming_holidays << holiday
      end
    end
    upcoming_holidays = upcoming_holidays.first(3)
  end
end
