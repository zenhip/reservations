module ProductsHelper
  
  def product_name(product)
     h(product.name)
  end
  
  # kish uz Product modeli un sauc kaa @product.batches.total_quantity
  def product_batches_quantity_total(product)
    product.batches.inject(0) {|q, batch| q + batch.quantity}
	end

	# arii kish uz modeli
	def product_batches_reserved_total(product)
    a=0
    for batch in product.batches
      a += batch.orders_from_batches.inject(0) {|q, orders_from_batch| q + orders_from_batch.quantity}
    end
    a
	end
  
  # modelii :)
	def product_batches_available_total(product)
    product_batches_quantity_total(product) - product_batches_reserved_total(product)
	end
	
end
