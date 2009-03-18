# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  before_filter :check_restricted_ips, :only => :create
  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      delete_login_attempts
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      flash[:notice] = "Logged in successfully"
      redirect_back_or_default(root_path)
    else
      unless ip_is_restricted?
        @login       = params[:login]
        @remember_me = params[:remember_me]
        flash[:notice] = "Could not log you in with '#{@login}'"
        render :action => 'new'
      else
        flash_and_redirect
      end
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected

  def check_restricted_ips
    restricted = RestrictedIp.find_by_remote_ip(request.remote_ip)
    if !restricted.blank?
      if restricted.created_at < Time.now.advance(:minutes => -1)
        RestrictedIp.delete(restricted)
      else
        restricted.update_attribute(:created_at, Time.now)
        flash_and_redirect
      end
    end
  end

  def ip_is_restricted?
    attempts = LoginAttempt.scoped_by_remote_ip(request.remote_ip).all
    if !attempts.blank? && attempts.size >= 3
      RestrictedIp.create(:remote_ip => request.remote_ip)
      LoginAttempt.delete(attempts)
    else
      LoginAttempt.create(:remote_ip => request.remote_ip, :user_agent => request.user_agent) and return false
    end
  end

  def delete_login_attempts
    attempts = LoginAttempt.scoped_by_remote_ip(request.remote_ip).all
    LoginAttempt.delete(attempts) unless attempts.blank?
  end
  
  def flash_and_redirect
    flash[:error] = "Your IP address is banned"
    redirect_to root_path and return false
  end
end
