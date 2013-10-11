class CreateBuckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.integer :cookies, limit: 8, default: 0
      t.string :type

      t.timestamps
    end
  end
end
