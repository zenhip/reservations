# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  
  before_filter :login_required
  
  helper_method :admin?
  
  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a1a9e8a7565d2a148ea9b9dc3a471646'
  
  # informācijai, nenorādot layout, rails provee izmantot application.html.erb layoutu
  layout("reserv")
  
  def ensure_admin
    admin? || access_denied
  end
  
  def admin?
    logged_in? && current_user.is?(:admin)
  end
  
end
