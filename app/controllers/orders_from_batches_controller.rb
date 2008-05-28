class OrdersFromBatchesController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :ensure_user_is_owner, :only => [:edit, :update, :destroy]
  
  before_filter :find_orders_from_batch_by_id, :only => [:edit, :update, :updated]
  
  def index
  end

  def new
  end

  def edit
    
  end

  def show
  end
  
  def create
  end
  
  def update
    if @orders_from_batch.update_attributes(params[:orders_from_batch])
      redirect_to updated_order_orders_from_batch_path(@orders_from_batch.order, @orders_from_batch)
    else
      flash[:error] = "izmainiit neizdevaas"
      render :action => :edit
    end
  end
  
  def destroy
  end
  
  protected
  
    def find_order_by_order_id
      @order = Order.find(params[:order_id])
    end
    
    def find_batch_by_batch_id
      @batch = Batch.find(params[:batch_id])
    end
    
    def find_orders_from_batch_by_id
      @orders_from_batch = OrdersFromBatch.find(params[:id])
    end
    
    
    def ensure_user_is_owner
      order_owner? || access_denied
    end
    
    def order_owner?
      logged_in? && selected_order.owner?(current_user) || admin?
    end
    
    def selected_order
      find_order_by_order_id
    end
    
end
