class CreateOrdersFromBatches < ActiveRecord::Migration
  def self.up
    create_table :orders_from_batches do |t|
      t.integer :order_id, :null => false
      t.integer :batch_id, :null => false
      t.datetime :leave_on, :null => false
      t.text :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :orders_from_batches
  end
end
