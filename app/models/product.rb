class Product < ActiveRecord::Base
  
  belongs_to :category
  
  has_many :batches, :dependent => :destroy, :order => "arrive_on desc" do
    # atgriež latest batch šim produktam (koments products/show.html.erb)
    def latest_batch
      
    end
    
    # # tas no ProductsHelper#product_batches_quantity_total
    # tik uzmet aci kaa tikt te pie produkta "Association extensions" 
    # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#M001103
    # def quantity
    #   
    # end
  end
  
  validates_presence_of :name, :category_id
  validates_uniqueness_of :name
  
  def self.find_all
    find(:all, :order => "name asc")
  end
  
  def self.find_latest
    find(:all, :order => "created_at desc", :limit => 5)
  end
  
  
	def batches_quantity
	 batches_quantity_total - batches_reserved_total + incomplete_orders_quantity
	end
	
	def incomplete_orders_quantity
	  q = 0
  	self.find_orders.each do |order|
       unless order.completed?
         q += order.orders_from_batches_quantity_sum
       end
    end
    q
	end
	
	def batches_available
	 batches_quantity - incomplete_orders_quantity
	end
	
	def batches_quantity_total
    self.batches.inject(0) {|q, batch| q + batch.quantity}
	end
	
	def batches_reserved_total
    a=0
    for batch in self.batches
      a += batch.orders_from_batches.inject(0) {|q, orders_from_batch| q + orders_from_batch.quantity}
    end
    a
	end
	
	def batches_available_total
    batches_quantity_total - batches_reserved_total
	end
	
	
	def orderable_batches(totamount)
	  x = 0
	  batchids = []
	  Batch.find(self.batches, :order => "arrive_on asc").each do |batch|
      if batch.available_total > 0
        unless totamount <= x
          x += batch.available_total
          batchids << batch
        end
      end
    end
    batchids
	end
	
  def find_orders
   x = []
   y = []
   self.batches.each do |batch|
     for order in batch.orders
       x << order
     end
   end
   x.uniq
   y = x.sort {|b,a| a.created_at <=> b.created_at}
  end
  
end
