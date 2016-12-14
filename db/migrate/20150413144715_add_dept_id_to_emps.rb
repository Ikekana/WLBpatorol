class AddDeptIdToEmps < ActiveRecord::Migration
  def change
    add_column :emps, :dept_id, :integer
  end
end
