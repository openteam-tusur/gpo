class Manage::ApplicationController < ApplicationController
  before_action :check_permissions

  rescue_from CanCan::AccessDenied do |exception|
    flash['error'] = t('cancan.access_denied')
    redirect_to root_url
  end

  layout 'application'

  def check_permissions
    authorize! :manage, :application
  end
end
