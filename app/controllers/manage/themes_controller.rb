# encoding: utf-8

class Manage::ThemesController < Manage::ApplicationController
  inherit_resources
  actions :all, except: :show

  def statistics
    @themes = Theme.find(:all, :order => 'id')
  end

  def projects
    @themes = Theme.find(:all, :order => 'id', :conditions => {:id => params[:themes]})
    if @themes.empty?
      flash[:error] = "Не выбрано ни одного направления"
      redirect_to statistics_themes_path
    end
  end

end

