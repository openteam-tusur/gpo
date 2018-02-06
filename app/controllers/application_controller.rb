class ApplicationController < ActionController::Base
  layout 'public'
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash['error'] = 'У вас нет прав для выполнения данного действия'

    redirect_to root_path
  end
end
