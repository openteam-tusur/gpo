class Manage::ApplicationController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    flash['error'] = t('cancan.access_denied')
    redirect_to root_url
  end

  layout 'application'
end
