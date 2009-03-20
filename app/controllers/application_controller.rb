# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  include AuthenticatedSystem

  before_filter :check
  
  def check
    logger.info { "\n\ncontroller name = #{self.controller_name}\n#{self.action_name}\n" }
    if self.controller_name == 'posts'
      logger.info { "is posts" }
    else
      logger.info { "is NOT posts" }
    end
  end
  
  def only_admin
    logged_in? && current_user.admin?
  end
  
end
