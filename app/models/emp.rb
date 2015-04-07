class Emp < ActiveRecord::Base
  
  has_many :depts, through: :assignments
  
  validates_uniqueness_of :code

  
  def self.to_csv(options = {})
    CSV.generate(options) do | csv |
      csv << [ "code", "name" ]
      all.each do | emp |
        row = Array.new
        row.push(emp.code.encode("Shift_JIS"))
        row.push(emp.name.encode("Shift_JIS"))
        csv << row
      end
    end
  end
  
  def self.from_csv(anArray)
    e = new
    e.code  = anArray[0]
    e.name  = anArray[1].to_s.encode('utf-8', 'sjis')
    return e    
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
