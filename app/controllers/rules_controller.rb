# encoding: utf-8

class RulesController < ApplicationController
  before_filter :find_rule, :except => [:index, :new, :create]

  def index
    @rules = Rule.find(:all, :order => "role")
#    authorize Rule.listable_by?(current_user)
  end

  def new
    @rule = Rule.new
#    authorize @rule.creatable_by?(current_user)
  end

  def edit
#    authorize @rule.updatable_by?(current_user)
  end

  def create
    @rule = Rule.new(Rule.attributes_from_params(params[:rule]))
#    authorize @rule.creatable_by?(current_user)
    
    if @rule.save
      flash[:notice] = 'Правило успешно добавлено'
      redirect_to(rules_url)
    else
      render :action => "new" 
    end
  end

  def update
#    authorize @rule.updatable_by?(current_user)
    
    if @rule.update_attributes(Rule.attributes_from_params(params[:rule]))
      flash[:notice] = 'Правило успешно обновлено'
      redirect_to(rules_url)
    else
      render :action => "edit"
    end
  end

  def destroy
#    authorize @rule.destroyable_by?(current_user)
    if Rule.administrators.count == 1 && @rule.admin?
      flash[:notice] = "Последний администратор не может быть удален"
      redirect_to(rules_url)
    else
      @rule.destroy
      flash[:notice] = "Правило успешно удалено"
      redirect_to(rules_url)
    end
  end
  
  protected
  def find_rule
    @rule = Rule.find(params[:id])
  end
end
