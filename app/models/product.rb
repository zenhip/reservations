class Product < ActiveRecord::Base
  
  belongs_to :category
  
  has_many :batches, :dependent => :destroy, :order => "arrive_on asc" do
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
    find(:all, :order => "name")
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
  
end
