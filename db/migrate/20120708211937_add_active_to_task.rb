class AddActiveToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :active, :integer
  end
end
