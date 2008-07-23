module ProductsHelper
  
  def product_name(product)
     h(product.name)
  end
  
  def product_availability_info
    "<b>Kopā (noliktavā):</b>
		daudzums:<b> #{@product.batches_quantity_total} (#{@product.batches_quantity})</b>,
		rezervēti:<b> #{@product.batches_reserved_total} (#{@product.incomplete_orders_quantity})</b>,
		brīvi:<b> #{@product.batches_available_total} (#{@product.batches_available})</b><br />"
  end
end
