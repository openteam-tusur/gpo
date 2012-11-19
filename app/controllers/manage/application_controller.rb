class Manage::ApplicationController < ApplicationController
  sso_authenticate_and_authorize

  layout 'application'
end
