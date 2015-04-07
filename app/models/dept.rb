require 'csv'

class Dept < ActiveRecord::Base
  
  has_many :emps, through: :assignments
  
  validates_uniqueness_of :code
  
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

end
