class OrdersController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :ensure_user_is_owner, :only => [:edit, :update, :destroy]
  
  before_filter :find_user_by_user_id, :only => [:index]
  before_filter :find_order_by_id, :only => [:show, :destroy, :edit, :update]
  #before_filter :find_batch_by_batch_id, :only => [:new, :create, :edit, :created, :destroy, :destroyed]
  before_filter :find_product_by_product_id, :only => [:new, :create]
  
  def index
    @page_title = @user.login.capitalize
    
    @orders = Order.find_all
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
    product = @order.find_product
    @order.destroy
    #redirect_to destroyed_batch_order_path(@batch, @order)
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
