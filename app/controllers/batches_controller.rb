class BatchesController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :ensure_admin, :except => [:index, :show]
  
  before_filter :find_product_by_product_id, :only => [:new, :create, :index]
  before_filter :find_batch_by_id, :only => [:show, :destroy, :edit, :update]
  
  def index
  end

  def new
    @batch = Batch.new
  end

  def edit
  end

  def show
  end
  
  def create
    @batch = @product.batches.build(params[:batch])#.slice(:arrival_date, :quantity))
    if @batch.save
      redirect_to product_path(@product)
    else
      render :action => :new
    end
  end
  
  def update
    #@batch.update_attributes(params[:batch].slice(:arrival_date, :quantity))
    if @batch.update_attributes(params[:batch])
      redirect_to batch_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    if @batch.orders_from_batches.any?
      flash[:error] = "Partiju nevar dzēst, ja tai ir rezervācijas"
    else
      @batch.destroy
      flash[:notice] = "Produkta partija dzēsta!"
    end
    redirect_to batch_path
  end
  
  protected

  def find_product_by_product_id
    @product = Product.find(params[:product_id])
  end
  
  def find_batch_by_id
    @batch = Batch.find(params[:id])
  end

end
