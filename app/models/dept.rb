require 'csv'

class Dept < ActiveRecord::Base
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
  
end
