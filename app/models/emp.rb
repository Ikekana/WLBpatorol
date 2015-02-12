class Emp < ActiveRecord::Base
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

end
