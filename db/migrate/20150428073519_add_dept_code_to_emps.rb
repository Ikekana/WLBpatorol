class AddDeptCodeToEmps < ActiveRecord::Migration
  def change
    add_column :emps, :dept_code, :string
  end
end
