class RemoveOrdersFromBatchesLeaveOn < ActiveRecord::Migration
  def self.up
    remove_column :orders_from_batches, :leave_on
  end

  def self.down
    add_column :orders_from_batches, :leave_on, :datetime
  end
end
