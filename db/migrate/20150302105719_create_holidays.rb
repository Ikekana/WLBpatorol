class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.date :holidaydate
      t.integer :year

      t.timestamps
    end
  end
end
