class AddColsToWorklogs < ActiveRecord::Migration
  def change
    add_column :worklogs, :holiday_id, :integer
    add_column :worklogs, :worktype_id, :integer
  end
end
