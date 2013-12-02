# encoding: utf-8

class Manage::SearchProjectsController < Manage::ApplicationController
  def index
    @chairs = Chair.all
    @themes = Theme.all
    chair = params[:chair].present? ? params[:chair] : nil
    theme = params[:theme].present? ? params[:theme] : nil
    interdisciplinary = params[:interdisciplinary].present? ? params[:interdisciplinary] : nil

    @projects = if params[:search].present? 
                  Project.search {
                    keywords params[:q]
                    with :chair, chair if chair
                    with :theme, theme if theme
                    with :state, 'active' if params[:active].present?
                    with :interdisciplinary, interdisciplinary if interdisciplinary
                  }.results
                else
                  []
                end
  end
end
