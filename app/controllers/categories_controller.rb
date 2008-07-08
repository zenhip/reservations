class CategoriesController < ApplicationController
  
  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :ensure_admin, :except => [:index, :show]
  
  before_filter :find_category_by_id, :only => [:edit, :update, :show, :destroy]
  
  def index
    @page_title = "Kategorijas"
    
    @categories = Category.find_all
    @products = Product.find_latest
    @batches = Batch.find_latest
    @orders = Order.find_latest
  end

  def new
    @page_title = "Pievienot jaunu kategoriju"
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category].slice(:name))
    if @category.save
      redirect_to categories_path
    else
      render :action => :new
    end
  end
  
  def edit
    @page_title = "Mainīt kategoriju"
  end

  def show
    @page_title = @category.name.capitalize
  end
  
  def update
    if @category.update_attributes(params[:category].slice(:name))
      redirect_to category_path
    else
      render :action => :edit
    end
  end

  def destroy
    if @category.products.any?
      flash[:error] = "Kategoriju nevar dzēst, ja tajā ir produkti"
    else
      @category.destroy
      flash[:notice] = "Kategorija dzēsta"
    end
    redirect_to categories_path
  end
  
  protected
  
    def find_category_by_id
      @category = Category.find(params[:id])
    end

end
