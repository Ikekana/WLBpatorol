class AddSysadminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sysadmin, :boolean
  end
end
