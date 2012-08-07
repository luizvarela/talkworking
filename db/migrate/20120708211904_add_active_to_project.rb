class AddActiveToProject < ActiveRecord::Migration
  def change
    add_column :projects, :active, :integer
  end
end
