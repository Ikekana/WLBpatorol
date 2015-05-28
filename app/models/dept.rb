require 'csv'

class Dept < ActiveRecord::Base
  
  # has_many :emps, through: :assignments
  
  has_many :emps
  has_many :worklogs, foreign_key: :dept_code
  
  self.primary_key = :code
  
  # validates_uniqueness_of :code
  
  def self.to_csv(options = {})
    CSV.generate(options) do | csv |
      csv << [ "code", "name" ]
      all.each do | dept |
        row = Array.new
        row.push(dept.code.encode("Shift_JIS"))
        row.push(dept.name.encode("Shift_JIS"))
        csv << row
      end
    end
  end
  
  def self.from_csv(anArray)
    d = new
    d.code  = anArray[0]
    d.name  = anArray[1].to_s.encode('utf-8', 'sjis')
    return d    
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
  

  def code_with_wildcard
    high = self.code.clone
    n    = high.length
    for i in 1..n do
      if high[n - i] == '0'
        high[n - i] = 'Z'
      else
        break
      end
    end
    return high
  end
  
  def code_range
    return self.code..self.code_with_wildcard
  end
  
  def all_depts_below
    Dept.where(:code => code_range)
  end
end
