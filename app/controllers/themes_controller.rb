# encoding: utf-8

class ThemesController < ApplicationController

  def index
    @themes = Theme.find(:all, :order => 'id')
  end

  def statistics
    @themes = Theme.find(:all, :order => 'id')
  end

  def projects
    @themes = Theme.find(:all, :order => 'id', :conditions => {:id => params[:themes]})
    if @themes.empty?
      flash[:error] = "Не выбрано ни одного направления"
      redirect_to statistics_themes_url
    end
  end

  def new
    @theme = Theme.new
  end

  def edit
    @theme = Theme.find(params[:id])
  end

  def create
    @theme = Theme.new(params[:theme])

    if @theme.save
      flash[:notice] = 'Направление успешно создано'
      redirect_to themes_url
    else
      render :action => "new"
    end
  end

  def update
    @theme = Theme.find(params[:id])

    if @theme.update_attributes(params[:theme])
      flash[:notice] = 'Направление успешно сохранено'
      redirect_to themes_url
    else
      render :action => "edit"
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy
    flash[:notice] = 'Направление удалено'
    redirect_to themes_url
  end
end

