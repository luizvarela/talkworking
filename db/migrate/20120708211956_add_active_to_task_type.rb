class AddActiveToTaskType < ActiveRecord::Migration
  def change
    add_column :task_types, :active, :integer
  end
end
