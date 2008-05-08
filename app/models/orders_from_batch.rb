class OrdersFromBatch < ActiveRecord::Base
  
  belongs_to :order
  belongs_to :batch
  
  validates_presence_of :leave_on, :quantity
  #validates_presence_of :order_id
  #validates_presence_of :batch_id
  
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0

  # Lai nevar "kopā: daudzums: 350, rezervēti: 390, brīvi: -40"
  # validate :quantity_is_not_greater_than_batch_quantity
    
  def self.find_all
    find(:all, :order => "created_at")
  end
  
  protected

    # def quantity_is_not_greater_than_batch_quantity
    #   if self.new_record?
    #     self.batch.available_quantity >= self.quantity
    #   else
    #     self.batch.available_quantity(self) => self.quantity
    #   end
    # end
  
end
