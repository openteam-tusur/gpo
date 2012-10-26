# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :find_user_chairs

  def dashboard
    @chair = @user_chairs.first
    redirect_to chair_url(@chair)
  end

  protected

  def find_user_chairs
    @user_chairs = Chair.all
  end
end
