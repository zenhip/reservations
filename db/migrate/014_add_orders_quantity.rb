class AddOrdersQuantity < ActiveRecord::Migration
  def self.up
    add_column :orders, :quantity, :integer
  end

  def self.down
    remove_column :orders, :quantity
  end
end
