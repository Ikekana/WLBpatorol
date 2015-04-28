class AddEmpCodeToWorklogs < ActiveRecord::Migration
  def change
    add_column :worklogs, :emp_code, :string
  end
end
