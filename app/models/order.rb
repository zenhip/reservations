class Order < ActiveRecord::Base
  
  belongs_to :user
  
  #has_many :batches, :through => :orders_from_batches
  has_many :orders_from_batches, :dependent => :destroy, :order => "created_at"
  
  validates_presence_of :user_id, :leave_on, :quantity
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 1
  
  def self.find_all
    find(:all, :order => "created_at")
  end
  
  def self.find_latest
    find(:all, :order => "created_at desc", :limit => 5)
  end
    
  def owner?(user)
    # tas noziimee, ka user ir nil
    # lieto (if user, ja useris vareetu arii nebuut):
    #
    # self.user_id == user.id 
    #
    # vai
    #
    # return unless user
    # self.user_id == user.id
    #
    return unless user
    self.user_id == user.id # /Users/zenhip/Documents/rails/reservations/app/models/order.rb:14: warning: Object#id will be deprecated; use Object#object_id
  end
  
  def orders_from_batch_attributes=(orders_from_batch_attributes)
    orders_from_batch_attributes.each do |attributes|
      orders_from_batches.build(attributes)
    end
  end
  
  
end
