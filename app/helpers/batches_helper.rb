module BatchesHelper
  
  # View Helperi ir paredzeeti vairaak vai mazaak view funkcijaam, te modelju logjikai toch nav jaadefinee.
  # Visu iespeejamo raksti modeljos kaa klases (def self.something) vai instances metodes (def something)
  
  # kish uz modeli :)
  def batch_reserved_total(batch)
    batch.total_ordered_quantity(batch)
  #  batch.orders_from_batches.inject(0) {|q, orders_from_batch| q + orders_from_batch.quantity}
	end
	
	# shim ir jaabuut modelii kopaa ar reserved_total
	def batch_available_total(batch)
	  batch.quantity - batch_reserved_total(batch)
	end
	
	# nav iisti ok ar logjiku
	# nav nepiecieshams savaakt visus batchus, lai samekleetu vajadziigo. to dari ar sql queriju Product modelii
	# kish uz modeli
	def next_batch(product, nextbatch)
	  batch_arrivals = []
	  for batch in product.batches
	    batch_arrivals << batch.arrive_on
	  end
	  batch_arrivals[nextbatch]
	end
	
end
