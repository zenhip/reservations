class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem
  
  skip_before_filter :login_required, :only => [:new, :create, :index, :show]
  before_filter :ensure_user_is_owner, :only => [:edit, :update]
  before_filter :ensure_admin, :only => [:destroy]
  
  before_filter :find_user_by_id, :only => [:edit, :update, :show, :destroy]
  
  def index
    @users = User.find_all
  end
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default(welcome_path)
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  def edit
  end

  def show
  end
  
  def update
    #atts = [:login, :email, :password, :password_confirmation]
    #atts << :role if current_user.is?(:admin)
    if @user.update_attributes(params[:user])#.slice(atts))
      redirect_to users_path
    else
      flash[:error] = "izmainiit neizdevaas"
      render :action => :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "lietotājs dzēsts"
    redirect_to users_path
  end
  
  protected
  
    def find_user_by_id
      @user = User.find(params[:id])
    end
    
    def ensure_user_is_owner
      account_owner? || access_denied
    end    
    
    def account_owner?
      logged_in? && selected_user.owner?(current_user) || admin?
    end
    
    def selected_user
      find_user_by_id
    end
    
end
