class AddDeptCodeToWorklogs < ActiveRecord::Migration
  def change
    add_column :worklogs, :dept_code, :string
  end
end
