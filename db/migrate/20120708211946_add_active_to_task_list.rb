class AddActiveToTaskList < ActiveRecord::Migration
  def change
    add_column :task_lists, :active, :integer
  end
end
