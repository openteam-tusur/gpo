class ApplicationController < ActionController::Base
  layout 'public'
  protect_from_forgery with: :exception
end
