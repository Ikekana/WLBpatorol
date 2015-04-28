class AddIsadminToEmps < ActiveRecord::Migration
  def change
    add_column :emps, :isadmin, :boolean
  end
end
