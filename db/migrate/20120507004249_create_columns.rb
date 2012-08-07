class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.string :title
      t.string :color
      t.integer :order
      t.integer :project_id

      t.timestamps
    end
  end
end
