class AddProductsVisible < ActiveRecord::Migration
  def self.up
    add_column :products, :visible, :integer, :default => 1
  end

  def self.down
    remove_column :products, :visible
  end
end
