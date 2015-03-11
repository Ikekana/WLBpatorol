class Holiday < ActiveRecord::Base
  before_save :prepare_save #
  
  def prepare_save
    self.year = self.holidaydate.year
    return true
  end
  
  def self.isHoliday?(aDay)
    return where(:Holidaydate => aDay).size > 0
  end
end