# encording: UTF-8

class Worklog < ActiveRecord::Base

  belongs_to :dept
  belongs_to :emp
  belongs_to :holidaytype
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
      puts '***** not found ***** <' + value.to_s + '>'
      return 1
    end
    return o.first.id
  end
  
  def workdayYM
    return self.workday.strftime("%m/%d")
  end
  
  def workdayYMwday
    wdays = ["日", "月", "火", "水", "木", "金", "土"]
    self.workdayYM + " (" + wdays[self.workday.wday] + ")"
  end
  
  def self.from_csv(anArray)
    w = new
    w.dept_id     = Dept.where(:code => anArray[0]).first.id              # 所属コード
    w.emp_id      = Emp.where(:code => anArray[1]).first.id               # 従業員
    w.workday     = Date.strptime(anArray[2], "%Y/%m/%d")           # 日付
    w.holidaytype_id  = get_id_from_class(Holidaytype,  :name, anArray[3].to_s.encode('utf-8', 'sjis'))          # 休暇
    w.worktype_id = get_id_from_class(Worktype, :name, anArray[4].to_s.encode('utf-8', 'sjis'))  # 勤務
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
  
  def day
    return self.workday.day
  end

  def self.extractOneMonth(year, month, emp)
    first = Date.new(year, month, 1)
    last  = Date.new(year, month, -1)
    anArray = Array.new()
    fromDB  = Hash.new()
    self.where(workday: first..last).each do | worklog |
      fromDB.store(worklog.day, worklog)
    end
    for i in 1..last.day
      log = fromDB.fetch(i, nil)
      if log.nil?
        log = Worklog.new(:workday => Date.new(year, month, i), :emp_id => emp.id)
        log.set_defaultAttributes
      end
      anArray.append(log)
    end
    return anArray
  end
  
  # 休日（土日＋祝日）であれば、それを示すＣＳＳのクラス名を返す
  def workday_css_class
  if self.workday.wday == 0 || self.workday.wday == 6
    return 'workday-off'.html_safe
  end
  if Holiday.isHoliday?(self.workday)
    return 'workday-off'.html_safe
  end
    return ''
  end
  
  def set_defaultAttributes
    year  = self.workday.year
    month = self.workday.month
    day   = self.workday.day
    
    @@defaultAttributes = {:rc_start=>Time.local(year,month,day, 00,00,00), :wk_start=>Time.local(year,month,day, 9,00,00), :rc_end=>Time.local(year,month,day, 00,00,00), :wk_end=>Time.local(year,month,day, 17,45,00) }
    
    self.attributes = @@defaultAttributes
    
    return self

  end

end