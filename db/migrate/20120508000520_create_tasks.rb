class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :body
      t.integer :task_list_id
      t.integer :user_id
      t.date :end
      t.integer :column_id

      t.timestamps
    end
  end
end
