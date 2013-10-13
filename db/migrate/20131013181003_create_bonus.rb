class CreateBonus < ActiveRecord::Migration
  def change
    create_table :bonus do |t|
      t.string :type, null: false
      t.integer :regeneration, null: false, default: 0
      t.integer :stockpile_id, null: false

      t.timestamps
    end

    add_index :bonus, :stockpile_id
  end
end
