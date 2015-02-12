class Worklog < ActiveRecord::Base

  belongs_to :dept
  belongs_to :emp
  belongs_to :holiday
  belongs_to :worktype
  validates_associated :dept, :emp
  
  def over_work_in_day?
    if self.work_minutes_in_day > 600
      return true
    end
    return false
  end
  
  def work_minutes_in_day
    diff = self.wk_end - self.wk_start
    return (( diff / 60 )  - self.rest)
  end
  
end
