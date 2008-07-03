class ProductsController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :ensure_admin, :except => [:index, :show]
  
  before_filter :find_category_by_category_id, :only => [:new, :create, :index]
  before_filter :find_product_by_id, :only => [:show, :destroy, :edit, :update]
  
  def index
  end
  
  def show
    
  end
  
  def update
    if @product.update_attributes(params[:product].slice(:name))
      redirect_to category_path(@product.category)
    else
      render :action => :edit
    end
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = @category.products.build(params[:product].slice(:name))
    if @product.save
      redirect_to category_path(@product.category)
    else
      render :action => :new
    end
  end
  
  def destroy
    if @product.batches.any?
      flash[:error] = "Produktu nevar dzēst, ja tam ir partijas"
      redirect_to category_path(@product.category)
    else
      @product.destroy
      flash[:notice] = "Produkts dzēsts"
      redirect_to category_path(@product.category)
    end
  end
  
  protected
  
    def find_category_by_category_id
      @category = Category.find(params[:category_id])
    end
    
    def find_product_by_id
      @product = Product.find(params[:id])
    end
      
end
