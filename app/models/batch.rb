class Batch < ActiveRecord::Base
  
  belongs_to :product
  
  has_many :orders, :through => :orders_from_batches, :dependent => :destroy#, :order => "created_at desc"
  has_many :orders_from_batches, :dependent => :destroy, :order => "created_at desc"
  
  validates_presence_of :arrive_on, :product_id, :quantity
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 1
  
  def self.find_all
    find(:all, :order => "arrive_on desc")
  end
    
  def self.find_latest
    find(:all, :order => "created_at desc", :limit => 5)
  end
  
  def find_orders
	  Order.find(self.orders, :order => "created_at desc")
	end
  
  # except_order_from_batch ir lai nepieskaitiitu aktiivo order_from_batch editeejot to
  # def available_quantity(except_order_from_batch=nil)
  #   self.quantity - total_ordered_quantity(nil, except_order_from_batch)
  # end
  
  def available_quantity_except_order_from_batch(order_from_batch)
    self.available_total + order_from_batch.quantity
  end
  
  # batch.orders_from_batches.inject(0) {|q, orders_from_batch| q + orders_from_batch.quantity}
  # def total_ordered_quantity
  #   #... paskaties uz ActiveRecord::Base#sum
  #   # http://api.rubyonrails.org/classes/ActiveRecord/Calculations/ClassMethods.html#M001341
  #   # (tur joinu vajadzees)
  # end
  def total_ordered_quantity
    self.orders_from_batches.inject(0) {|q, orders_from_batch| q + orders_from_batch.quantity}
	end
	
  def reserved_total
    self.total_ordered_quantity
	end
	
	def available_total
	  self.quantity - reserved_total
	end
	
	# nav iisti ok ar logjiku
	# nav nepiecieshams savaakt visus batchus, lai samekleetu vajadziigo. to dari ar sql queriju Product modelii
	# kish uz modeli
	#def next_batch(product, nextbatch)
	#  batch_arrivals = []
	#  for batch in product.batches
	#    batch_arrivals << batch.arrive_on
	#  end
	#  batch_arrivals[nextbatch]
	#end
	
end
