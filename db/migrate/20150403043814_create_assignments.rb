class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :dept, index: true
      t.references :emp, index: true

      t.timestamps
    end
  end
end
