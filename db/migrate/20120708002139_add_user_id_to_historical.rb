class AddUserIdToHistorical < ActiveRecord::Migration
  def change
    add_column :historicals, :user_id, :integer
  end
end
