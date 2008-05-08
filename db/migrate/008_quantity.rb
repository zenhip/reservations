class Quantity < ActiveRecord::Migration
  def self.up
    add_column "orders_from_batches", "quantity", :integer
  end

  def self.down
    remove_column "orders_from_batches", "quantity"
  end
end
