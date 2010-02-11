class SessionsController < ApplicationController
  filter_access_to :all

  before_filter :login_required, :only => [:dashboard]

  # render new.rhtml
  def new
    if logged_in?
      redirect_to dashboard_url
    end
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
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_to dashboard_url
      flash[:notice] = "Добро пожаловать"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def dashboard
    if current_user.any_mentor? || current_user.any_manager?
      @chair = @user_chairs.first
      redirect_to chair_url(@chair)
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Вы вышли из системы"
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Ошибка! Вход в систему не удался"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
