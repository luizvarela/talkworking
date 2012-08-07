class AddActiveToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :active, :integer
  end
end
