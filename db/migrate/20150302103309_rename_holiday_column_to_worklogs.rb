class RenameHolidayColumnToWorklogs < ActiveRecord::Migration
  def change
    rename_column :worklogs, :holiday_id, :holidaytype_id
  end
end
