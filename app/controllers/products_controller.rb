class ProductsController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :ensure_admin, :except => [:index, :show]
  
  before_filter :find_category_by_category_id, :only => [:new, :create, :index]
  before_filter :find_product_by_id, :only => [:show, :destroy, :edit, :update]
  
  def index
  end
  
  def show
    @page_title = @product.name
    @page_id = "product_category_#{@product.category.id}"
    
  end
  
  def update
    if @product.update_attributes(params[:product].slice(:name))
      redirect_to category_path
    else
      render :action => :edit
    end
  end
  
  def new
    @page_title = "Jauns produkts"
    @page_id = "product_category_#{@category.id}"
    
    @product = Product.new
  end
  
  def edit
    @page_title = "Mainīt produktu"
    @page_id = "product_category_#{@product.category.id}"
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
