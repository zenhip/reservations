class Category < ActiveRecord::Base
  
  has_many :products, :dependent => :destroy, :order => "name asc"
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
  def self.find_all
    find(:all, :order => "name asc")
  end
  
end
