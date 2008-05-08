class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name, :limit => 255, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
