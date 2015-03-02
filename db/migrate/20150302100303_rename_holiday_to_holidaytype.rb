class RenameHolidayToHolidaytype < ActiveRecord::Migration
  def change
    rename_table :holidays, :holidaytypes
  end
end
