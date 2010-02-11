# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  layout "application"

  before_filter :set_current_user
  before_filter :find_user_chairs

  rescue_from Authorization::NotAuthorized, :with => :permission_denied

  rescue_from ActiveResource::ServerError, :with => :resource_not_found

  include AuthenticatedSystem

  include ExceptionNotifiable

  def permission_denied
    if current_user
      flash[:error] = t('access_denied')
      render :file => 'app/views/shared/access_denied.html.erb', :layout => 'error.html.erb', :status => 403
    else
      flash[:error] = t('login_required')
      redirect_to login_path, :status => 403
    end
  end

#  вместо старого оповещателя теперь используем плугин ExceptionNotifiable
#  по большому счету метод ниже можно зачистить
#
#  def rescue_action(exception)
#    if RAILS_ENV == "production"
#      ReportMailer.deliver_application_error(exception)
#      flash[:error] = "Непредвиденная ошибка системы. Отчет отправлен разработчикам."
#      redirect_to(root_path)
#    else
#      super
#    end
#  end

  protected

  def find_user_chairs
    chairs = []
    if logged_in?
      chairs = Chair.find(:all, :order => :abbr)
      unless current_user.admin? || current_user.supervisor?
        chairs = chairs.select do |chair|
          chair.permitted_to?(:read) rescue false
        end
      end
    end
    @user_chairs = chairs
  end

  def set_current_user
    Authorization.current_user = current_user
  end


  def resource_not_found
    flash[:error] = "Студент не найден"
  end
end

