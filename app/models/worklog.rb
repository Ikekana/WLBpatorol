# encording: UTF-8

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
  
  def self.get_id_from_class(aClass, attr, value)
    o = aClass.where(attr => value)
      if o.empty?
      return 1
    end
    return o.first.id
  end
  
  def self.from_csv(anArray)
    w = new
    w.dept_id     = Dept.where(:code => anArray[0]).first.id              # 所属コード
    w.emp_id      = Emp.where(:code => anArray[1]).first.id               # 従業員
    w.workday     = Date.strptime(anArray[2], "%Y/%m/%d")           # 日付
    w.holiday_id  = get_id_from_class(Holiday,  :name, anArray[3])          # 休暇
    w.worktype_id = get_id_from_class(Worktype, :name, anArray[4])  # 勤務
    w.rc_start    = Time.strptime(anArray[5],"%H:%M")               # 出勤
    w.wk_start    = Time.strptime(anArray[6],"%H:%M")               # 始業
    w.wk_end      = Time.strptime(anArray[7],"%H:%M")               # 終業
    w.rc_end      = Time.strptime(anArray[8],"%H:%M")               # 退勤
    w.rest        = anArray[9].to_i                                 # 休憩
    w.reason      = anArray[10].to_s.encode('utf-8', 'sjis')        # 乖離理由
    w.comment     = anArray[11].to_s.encode('utf-8', 'sjis')        # 備考
    w.check       = anArray[12].to_s.encode('utf-8', 'sjis')        # チェック
 
    return w   
  end

end
