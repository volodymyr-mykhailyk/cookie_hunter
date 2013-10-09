class CreateStockpiles < ActiveRecord::Migration
  def change
    create_table :stockpiles do |t|
      t.integer :hunter_id, null: false
      t.integer :cookies, limit: 8, default: 0
      t.integer :regeneration, default: 0

      t.timestamps
    end

    add_index :stockpiles, :hunter_id
  end
end
