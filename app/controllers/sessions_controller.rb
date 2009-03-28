# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    @login       = params[:login]
    @remember_me = params[:remember_me]
    @user = User.with_allowed_states.find_by_login(@login)
    if @user
      case @user.aasm_current_state
      when :suspended
        flash_and_render(:error, "Your account is suspended")
      when :locked_out
        if @user.lock_out_ended?
          LoginAttempt.delete(@user.login_attempts)
          @user.end_lock_out!
          proceed_to_login
        else
          flash_and_render(:error, "Your account is locked out")
        end
      else # is active
        proceed_to_login
      end
    else
      flash_and_render
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  
  def proceed_to_login
    if @user.authenticated?(params[:password])
      self.current_user = @user
      LoginAttempt.delete(@user.login_attempts)
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      flash[:success] = "Logged in successfully"
      redirect_back_or_default(root_path)
    else
      @user.login_attempts.create(:remote_ip => request.remote_ip, :user_agent => request.user_agent)
      if @user.max_login_attempts?
        @user.lock_out!
        flash_and_render(:error, "Your account is locked out")
      else
        flash_and_render
      end
    end
  end
  
  def flash_and_render(type = :notice, message = "Incorrect username or password")
    flash[type] = message
    # done to clear out unneeded flash values since this isn't a redirect...know a better way to do this?
    flash.delete_if {|key, value| key != type }
    render :action => 'new'
  end

end
