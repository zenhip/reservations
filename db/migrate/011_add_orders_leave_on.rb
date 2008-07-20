class AddOrdersLeaveOn < ActiveRecord::Migration
  def self.up
    add_column :orders, :leave_on, :datetime
  end

  def self.down
    remove_column :orders, :leave_on
  end
end
