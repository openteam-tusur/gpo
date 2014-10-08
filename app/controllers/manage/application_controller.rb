class Manage::ApplicationController < ApplicationController
  load_and_authorize_resource :class => false

  rescue_from CanCan::AccessDenied do |exception|
    flash['error'] = exception.message
    redirect_to root_url
  end

  layout 'application'
end
