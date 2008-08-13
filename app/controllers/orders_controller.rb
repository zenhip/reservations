class OrdersController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :ensure_user_is_owner, :only => [:edit, :update, :destroy]
  
  before_filter :find_user_by_user_id, :only => [:index]
  before_filter :find_order_by_id, :only => [:show, :destroy, :edit, :update]
  #before_filter :find_batch_by_batch_id, :only => [:edit, :update]
  before_filter :find_product_by_product_id, :only => [:new, :create, :edit]
  
  def index
    @page_title = @user.login.capitalize
    
    #@orders = Order.find_all
    @user_orders_list = Order.paginated_list(@user, params[:page])
    @user_not_completed_orders_list = Order.paginated_not_completed_list(@user, params[:page])
  end
  
  def show
    @page_title = @order.created_at.to_s(:short_date)
    @page_id = "product_category_#{@order.find_product.category.id}"
  end
  
  def edit
    @page_title = "Mainīt rezervāciju"
    @page_id = "product_category_#{@order.find_product.category.id}"
  end
  
  def update
    @product = @order.find_product
    unless @order.completed?
      #orderamount = @order.attributes[:quantity].to_i # 0
      testorder = Order.new(params[:order])
      orderamount = testorder.quantity
      #quantity_sum = @product.batches_available_total + @order.orders_from_batches_quantity_sum
      quantity_sum = @order.quantity_available_total_for_update
      totamount = orderamount - @order.orders_from_batches_quantity_sum    
    
      if orderamount > quantity_sum
        flash[:error] = "nevar rezervēt vairāk kā noliktavā pieejams"
        redirect_to edit_product_order_path(@product, @order)
      elsif orderamount <= 0
        flash[:error] = "par maz"
        redirect_to edit_product_order_path(@product, @order)
      else
        # ja daudzums lielaaks kaa bija - taisam jaunus orders_from_batches
        if totamount > 0
        	@product.orderable_batches(totamount).each do |batch|
        	  order_from_batch_amount = 0
        	  if batch.available_total <= totamount
        	    order_from_batch_amount = batch.available_total
        	    totamount -= batch.available_total
        	  else
        	    order_from_batch_amount = totamount
        	  end
        	  @order.orders_from_batches.build(:batch_id => batch.id, :quantity => order_from_batch_amount)
        	end
        	if @order.save && @order.update_attributes(params[:order])
            flash[:notice] = "izmainīts!"
            redirect_to product_path(@product)
          else
            render :action => :edit
          end
        # ja daudzums mazāks kaa bija - panjemam vajadziigo no esoshajiem orders_from_batches
        # paareejos orders_from_batches dzeesham
        elsif totamount < 0
        	@order.orders_from_batches.each do |ofb|
        		order_from_batch_amount = 0
        		unless orderamount == 0
          		if ofb.quantity <= orderamount
          	    order_from_batch_amount = ofb.quantity
          	    orderamount -= ofb.quantity
          	  else
          	    order_from_batch_amount = orderamount
          	    orderamount = 0
          	  end
        	    ofb.update_attribute(:quantity, order_from_batch_amount)
      	    else
      	      ofb.destroy
      	    end
        	end
        	if @order.save && @order.update_attributes(params[:order])
            flash[:notice] = "izmainīts!"
            redirect_to product_path(@product)
          else
            render :action => :edit
          end
        # ja daudzums palicis nemainiigs - vienk updeitojam orderi
        else
      	  if @order.update_attributes(params[:order])
            flash[:notice] = "orderis izmainīts!"
            redirect_to product_path(@product)
          else
            render :action => :edit
          end
    	  end
      end
    else
      if @order.update_attributes(params[:order].slice(:completed))
        flash[:notice] = "orderis aktīvs!"
        redirect_to product_path(@product)
      else
        render :action => :edit
      end
    end
  end
  
  def new
    @page_title = "Jauna rezervācija"
    @page_id = "product_category_#{@product.category.id}"
    
    @order = Order.new
    @order.quantity = 0
  end
  
  def create
    @order = Order.new(params[:order])
    @order.user = current_user
    
    if @order.quantity > @product.batches_available_total
      flash[:error] = "nevar rezervēt vairāk kā noliktavā pieejams"
      redirect_to new_product_order_path(@product)
    elsif @order.quantity <= 0
      flash[:error] = "par maz"
      redirect_to new_product_order_path(@product)
    else
      totamount = @order.quantity
      @product.orderable_batches(totamount).each do |batch|
        order_from_batch_amount = 0
        if batch.available_total <= totamount
          order_from_batch_amount = batch.available_total
          totamount -= batch.available_total
        else
          order_from_batch_amount = totamount
        end
        @order.orders_from_batches.build(:batch_id => batch.id, :quantity => order_from_batch_amount)
      end
      
      if @order.save
        flash[:notice] = "rezervācija veiksmīga!"
        redirect_to product_path(@product)
      else
        render :action => :new
      end
    end
  end
  
  def created
  end
  
  def destroy
    if @order.completed?
      flash[:error] = "orderis atzīmēts kā izpildīts"
    else
      product = @order.find_product
      @order.destroy
    end
    redirect_to product_path(product)
  end
  
  def destroyed
  end
  
  protected
  
  def find_user_by_user_id
    @user = User.find(params[:user_id])
  end
  
  def find_order_by_id
    @order = Order.find(params[:id])
  end
  
  def find_batch_by_batch_id
    @batch = Batch.find(params[:batch_id])
  end
  
  def find_product_by_product_id
    @product = Product.find(params[:product_id])
  end
  
  
  def ensure_user_is_owner
    order_owner? || access_denied
  end
  
  def order_owner?
    logged_in? && selected_order.owner?(current_user) || admin?
  end
  
  def selected_order
    find_order_by_id
  end
  
end
