class RemoveOrdersFromBatchesComment < ActiveRecord::Migration
  def self.up
    remove_column :orders_from_batches, :comment
  end

  def self.down
    add_column :orders_from_batches, :comment, :text
  end
end
