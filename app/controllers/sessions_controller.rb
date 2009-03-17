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
      self.current_user = user
      counts = LoginAttempt.find(:all, :conditions => { :remote_ip => request.remote_ip })
      LoginAttempt.delete(counts) unless counts.blank?
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      flash[:notice] = "Logged in successfully"
      redirect_back_or_default(root_path)
    else
      @login       = params[:login]
      @remember_me = params[:remember_me]
      # note_failed_signin
      unless last_login_attempt?
        flash[:notice] = "Could not log you in with '#{@login}'"
        render :action => 'new'
      else
        flash[:error] = "your ip is banned"
        redirect_to root_path
      end
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected

  def last_login_attempt?
    counts = LoginAttempt.find(:all, :conditions => { :remote_ip => request.remote_ip })
    if !counts.blank? && counts.size >= 3
      restriction = RestrictedIp.create(:remote_ip => request.remote_ip)
      # maybe not best to destroy them all, for keeping records sake
      LoginAttempt.delete(counts)
      true
    else
      attempt = LoginAttempt.create(:remote_ip => request.remote_ip, :user_agent => request.user_agent)
      false
    end
  end

end
