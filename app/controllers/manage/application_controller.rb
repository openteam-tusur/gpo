class Manage::ApplicationController < ApplicationController
  before_action :check_permissions

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    flash[:error] = 'Что-то пошло не так с вашей сессией, попробуйте войти еще раз'

    redirect_to root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash['error'] = t('cancan.access_denied')
    redirect_to root_url
  end

  layout 'application'

  def check_permissions
    authorize! :manage, :application
  end
end
