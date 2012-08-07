class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.string :title
      t.integer :user_id
      t.integer :comentavel_id
      t.string :comentavel_type

      t.timestamps
    end
    add_index :comments, :comentavel_type
    add_index :comments, :comentavel_id
  end
end
