class CreateHolidaytypes < ActiveRecord::Migration
  def change
    create_table :holidaytypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
