class RemoveDeptIdFromEmps < ActiveRecord::Migration
  def change
    remove_column :emps, :dept_id, :integer
  end
end
