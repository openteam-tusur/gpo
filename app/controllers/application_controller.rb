class ApplicationController < ActionController::Base
  layout 'public'
  protect_from_forgery with: :exception

  helper_method :current_namespace

  rescue_from CanCan::AccessDenied do |exception|
    flash['error'] = 'У вас нет прав для выполнения данного действия'

    redirect_to root_path
  end

  def current_namespace
    @current_namespace = controller_path.split('/').first.to_sym
  end
end
