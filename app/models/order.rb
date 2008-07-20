class Order < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :batches, :through => :orders_from_batches, :order => "arrive_on asc"
  has_many :orders_from_batches, :dependent => :destroy, :order => "created_at asc"
  
  validates_presence_of :user_id, :leave_on, :quantity
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 1
  
  def self.find_all
    find(:all, :order => "created_at asc")
  end
  
  def self.find_latest
    find(:all, :order => "created_at desc", :limit => 5)
  end
  
  def find_product
    self.batches.find(:first).product
  end
  
  def orders_from_batches_quantity_sum
    self.orders_from_batches.inject(0) {|q, orders_from_batch| q + orders_from_batch.quantity}
  end
  
  def batches_for_update(orderamount)
    x = 0
    batchids = []
    self.orders_from_batches.each do |ofb|
      unless orderamount <= x
        x += ofb.batch.available_quantity_except_order_from_batch(ofb)
        batchids << ofb.batch
      end
    end
    batchids
  end
  
  def quantity_available_total_for_update
    self.find_product.batches_available_total + self.orders_from_batches_quantity_sum
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
