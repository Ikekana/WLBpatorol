class CreateWorklogs < ActiveRecord::Migration
  def change
    create_table :worklogs do |t|
      t.references :dept, index: true
      t.references :emp, index: true
      t.date :workday
      t.string :holiday
      t.string :worktype
      t.time :rc_start
      t.time :wk_start
      t.time :wk_end
      t.time :rc_end
      t.integer :rest
      t.string :reason
      t.string :comment
      t.string :check

      t.timestamps
    end
  end
end
