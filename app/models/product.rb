class Product < ActiveRecord::Base
  
  belongs_to :category
  
  # datumu laukus labaak saukt _on (datums), _at (datums+laiks)
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
  
end
