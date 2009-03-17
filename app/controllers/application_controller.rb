# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  include AuthenticatedSystem

  def only_admin
    logged_in? && current_user.admin?
  end
  
  def check_restricted_ips
    restricted = RestrictedIp.find_by_remote_ip(request.remote_ip)
    if !restricted.blank?
      if restricted.created_at < Time.now.advance(:minutes => -1)
        RestrictedIp.delete(restricted)
      else
        restricted.update_attribute(:created_at, Time.now)
        flash[:error] = "your ip is banned"
        redirect_back_or_default(root_path) and return false
      end
    else
      true
    end
  end
end
