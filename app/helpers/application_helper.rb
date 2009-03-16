# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def is_admin?
    logged_in? && current_user.admin?
  end
end
