module UsersHelper
  
  Roles = {
    'admin' => 'Administrātors',
    'user' => 'Lietotājs'
  }
  
  def user_login(user)
    h(user.login)
  end
  
  def user_role(user)
    (user.role)
  end
  
  def user_roles_for_select
    User::ROLES.collect { |role| [Roles[role].capitalize, role] }
  end
  
  def current_user_is_account_owner(user)
    user.owner?(current_user)
  end
  
end