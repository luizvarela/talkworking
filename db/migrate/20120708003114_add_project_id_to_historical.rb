class AddProjectIdToHistorical < ActiveRecord::Migration
  def change
    add_column :historicals, :project_id, :integer
  end
end
