class CreateDepts < ActiveRecord::Migration
  def change
    create_table :depts do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
