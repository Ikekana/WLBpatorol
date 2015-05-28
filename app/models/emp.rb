class Emp < ActiveRecord::Base
  
  # has_many :depts, through: :assignments
  
  belongs_to :dept, :foreign_key => "dept_code"
  
  self.primary_key = :code
  # validates_uniqueness_of :code

  
  def self.to_csv(options = {})
    CSV.generate(options) do | csv |
      csv << [ "code", "name" ]
      all.each do | emp |
        row = Array.new
        row.push(emp.code.encode("Shift_JIS"))
        row.push(emp.name.encode("Shift_JIS"))
        row.push(emp.dept_code.encode("Shift_JIS"))
        csv << row
      end
    end
  end
  
  def self.from_csv(anArray)
    e = new
    e.code      = anArray[0]
    e.name      = anArray[1].to_s.encode('utf-8', 'sjis')
    e.dept_code = anArray[2]
    e.set_isAdmin_from_code(anArray[3])
    return e    
  end
  
  # 役職コードをもとに管理者フラグ（isadmon）をセットする
  def set_isAdmin_from_code(code)
    # 管理者コード60がマネージャなので、それよりも大きい場合は一般社員と判断する
    puts "code is : " + code.to_s
    if code > "60"
      self.isadmin = false
    else
      self.isadmin = true
    end
  end
  
  # 暗号化
  def encryptor 
    secret = 'ogis-ri_human_resource_ogis-ri_human_resource'             
    ::ActiveSupport::MessageEncryptor.new(secret)                
  end

  def name=(val)
    write_attribute("name", self.encryptor.encrypt_and_sign(val))             
  end 

  def name
    self.encryptor.decrypt_and_verify(read_attribute("name"))          
  end  

  def uncoded_name=(val)
    write_attribute("name", self.encryptor.encrypt_and_sign(val))             
  end 

  def uncoded_name
    if read_attribute("name").blank?
      return ''
    end
    self.encryptor.decrypt_and_verify(read_attribute("name"))          
  end  
  
  def deptname
    return '' if self.dept.nil?
    return self.dept.name
  end
  
  def depts_i_can_see
    return self.dept.all_depts_below
  end
end
