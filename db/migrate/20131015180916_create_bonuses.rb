class CreateBonuses < ActiveRecord::Migration
  def change
    create_table :bonuses do |t|
      t.string :type, null: false
      t.integer :regeneration, null: false, default: 0
      t.integer :clicks, null: false, default: 0
      t.integer :steals, null: false, default: 0
      t.integer :saves, null: false, default: 0
      t.integer :stockpile_id, null: false

      t.timestamps
    end

    add_index :bonuses, :stockpile_id
  end
end
