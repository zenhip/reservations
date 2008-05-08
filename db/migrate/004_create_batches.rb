class CreateBatches < ActiveRecord::Migration
  def self.up
    create_table :batches do |t|
      t.integer :product_id, :null => false
      t.integer :quantity, :default => 0
      t.datetime :arrive_on, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :batches
  end
end
