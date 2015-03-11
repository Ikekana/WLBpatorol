class AddCommentToHolidays < ActiveRecord::Migration
  def change
    add_column :holidays, :comment, :string
  end
end
