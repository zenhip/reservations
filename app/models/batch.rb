class Batch < ActiveRecord::Base
  
  belongs_to :product
  
  has_many :orders_from_batches, :dependent => :destroy, :order => "created_at asc"
  
  validates_presence_of :arrive_on, :product_id, :quantity
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0
  
  def self.find_all
    find(:all, :order => "arrive_on asc")
  end
  
  # except_order_from_batch ir lai nepieskaitiitu aktiivo order_from_batch editeejot to
  # def available_quantity(except_order_from_batch=nil)
  #   self.quantity - total_ordered_quantity(nil, except_order_from_batch)
  # end
  
  # batch.orders_from_batches.inject(0) {|q, orders_from_batch| q + orders_from_batch.quantity}
  # def total_ordered_quantity
  #   #... paskaties uz ActiveRecord::Base#sum
  #   # http://api.rubyonrails.org/classes/ActiveRecord/Calculations/ClassMethods.html#M001341
  #   # (tur joinu vajadzees)
  # end
  def total_ordered_quantity(batch)
    # SQLite3::SQLException: ambiguous column name: quantity
    # droshi vien deelj quantity abaas tabulaas
    #Batch.sum('quantity', :joins => "LEFT JOIN orders_from_batches on orders_from_batches.batch_id = batch.id")
    batch.orders_from_batches.inject(0) {|q, orders_from_batch| q + orders_from_batch.quantity}
	end
 
end
