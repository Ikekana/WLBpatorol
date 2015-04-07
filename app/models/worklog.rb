# encording: UTF-8

class Worklog < ActiveRecord::Base

  belongs_to :dept
  belongs_to :emp
  belongs_to :holidaytype
  belongs_to :worktype
  validates_associated :dept, :emp
  
  # 一日10時間（休憩を除く）以上作業していたらtrueを返す。
  def over_work_in_day?
    if self.work_minutes_in_day > 600
      return true
    end
    return false
  end
  
  # 一日の作業時間（休憩を除く）を分で返す。
  def work_minutes_in_day
    diff = self.wk_end - self.wk_start
    return (( diff / 60 )  - self.rest)
  end
  
  # マスタから名前を逆引きして、そのマスタデータのidを返す。
  # 見つからなかったらidとして1をセットする。
  def self.get_id_from_class(aClass, attr, value)
    o = aClass.where(attr => value)
    if o.empty?
      puts '***** not found ***** <' + value.to_s + '>'
      return 1
    end
    return o.first.id
  end
  
  # 作業日(属性workday)をmm/dd形式で返す。
  def workdayYM
    return self.workday.strftime("%m/%d")
  end
  
  # 作業日(属性workday)をmm/dd形式＋曜日で返す。
  def workdayYMwday
    @@wdays = ["日", "月", "火", "水", "木", "金", "土"]
    self.workdayYM + " (" + @@wdays[self.workday.wday] + ")"
  end
  
  # CSVを解析してworklogオブジェクトを作成して返す。
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
  
  # 作業日の日付部分だけをintegerとして返す。
  def day
    return self.workday.day
  end

  # 一か月分のworklogをDBから抽出し、Arrayにして返す。
  # DBに存在しない場合は、新規オブジェクトを作成してArrayにセットする
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
        log.save
      end
      log.dept_id = 1652 # 仮実装
      # 今日のレコードがあれば、現在時刻に応じて作業開始あるいは終了時間に現在時刻をセットする
      # ワンクリック登録を作ったので、いったん機能を停止
      # if log.current_day?
      # current_clock = Time.zone.now
      #  if current_clock.hour < 13
      #    log.wk_start = current_clock
      #  else
      #    log.wk_end   = current_clock
      #  end
      #end
      anArray.append(log)
    end
    return anArray
  end
  
  # 作業日が休日（土日or祝日）か否かを返す（労働日の場合はFalse）
  # 現状、土日は無条件に休日と見なし、その上でHolidaysマスタにエントリがあれば休日とみなしている
  def isOff? 
    if self.workday.wday == 0 || self.workday.wday == 6
      return true
    end
    if Holiday.isHoliday?(self.workday)
      return true
    end
    return false
  end
  
  # 休日であれば、そのことを示すＣＳＳのクラス名を返す
  def workday_css_class
    if self.isOff?
      return 'workday-off'.html_safe
    end
    return ''
  end
  
  # 新規オブジェクトを作成する際に、デフォルト値をセットする。
  def set_defaultAttributes
    year  = self.workday.year
    month = self.workday.month
    day   = self.workday.day
    
    @@workdayAttributes = {:rc_start=>Time.local(year,month,day, 00,00,00), :wk_start=>Time.local(year,month,day, 9,00,00), :rc_end=>Time.local(year,month,day, 00,00,00), :wk_end=>Time.local(year,month,day, 17,45,00), :rest=>60}
    
    @@holidayAttributes = {:rc_start=>Time.local(year,month,day, 00,00,00), :wk_start=>Time.local(year,month,day, 00,00,00), :rc_end=>Time.local(year,month,day, 00,00,00), :wk_end=>Time.local(year,month,day, 00,00,00), :rest=>0 }
    
    if isOff?
      self.attributes = @@holidayAttributes
      self.holidaytype_id = 2
      self.worktype_id    = 2
    else
      self.attributes = @@workdayAttributes
      self.holidaytype_id = 1
      self.worktype_id    = 1
    end
    
    return self

  end

  def current_day?
    return (self.workday == Date.current)
  end
  
  def today_mark
    if current_day?
      return '◆'
    end
    return ' '
  end
    
end