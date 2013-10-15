class DropBonuses < ActiveRecord::Migration
  def up
    remove_index :bonus, :stockpile_id
    drop_table :bonus
  end

  def down
    create_table :bonus do |t|
      t.string :type, null: false
      t.integer :regeneration, null: false, default: 0
      t.integer :stockpile_id, null: false

      t.timestamps
    end

    add_index :bonus, :stockpile_id
  end
end
