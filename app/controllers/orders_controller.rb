class OrdersController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :ensure_user_is_owner, :only => [:edit, :update, :destroy]
  
  before_filter :find_user_by_user_id, :only => [:index]
  #before_filter :find_order_by_id, :only => [:show, :destroy, :edit, :update]
  #before_filter :find_batch_by_batch_id, :only => [:new, :create, :edit, :created, :destroy, :destroyed]
  before_filter :find_product_by_product_id, :only => [:new, :create]
  
  def index
    @orders = Order.find_all
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def new
    @order = Order.new
    #@order.orders_from_batches.build(:batch_id => @batch.id, :leave_on => Time.now.to_s(:short_date))
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
      validate :ensure_order_less_than_in_batch
      def ensure_order_is_less_than_omg_kas_tur
       errors.add(:ievadlauks, "errors") if self.batch_count < self.lauks.to_i
      end
      
      #if @order.save
      flash[:notice] = "cool!"
      redirect_to new_product_order_path(@product)
      #  redirect_to created_batch_order_path(@batch, @order)
      #else
      #  puts @order.errors.inspect
      #end
    end
  end
  
  def created
  end
  
  def destroy
    @order.destroy
    redirect_to destroyed_batch_order_path(@batch, @order)
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
