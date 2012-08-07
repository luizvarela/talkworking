class CreateHistoricals < ActiveRecord::Migration
  def change
    create_table :historicals do |t|
      t.string :title
      t.text :description
      t.integer :historical_id
      t.string :historical_type

      t.timestamps
    end
  end
end
