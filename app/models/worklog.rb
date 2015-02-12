class Worklog < ActiveRecord::Base
  belongs_to :dept
  belongs_to :emp
end
