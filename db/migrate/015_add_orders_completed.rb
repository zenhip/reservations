class AddOrdersCompleted < ActiveRecord::Migration
  def self.up
    add_column :orders, :completed, :integer, :default => 0
  end

  def self.down
    remove_column :orders, :completed
  end
end
