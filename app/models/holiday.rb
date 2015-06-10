class Holiday < ActiveRecord::Base
  before_save :prepare_save #
  
  def prepare_save
    self.year = self.holidaydate.year
    return true
  end
  
  def self.isHoliday?(aDay)
    return where(:holidaydate => aDay).size > 0
  end
 
  def self.isOff?(aDay)  
    if aDay.wday == 0 || aDay.wday == 6
      return true
    end
    return self.isHoliday?(aDay)
  end
  
end