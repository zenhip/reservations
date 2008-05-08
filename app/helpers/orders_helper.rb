module OrdersHelper
  
  def current_user_is_order_owner(order)
    order.owner?(current_user)
  end
  
end
