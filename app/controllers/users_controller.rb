# encoding: utf-8

class UsersController < ApplicationController
  before_filter :find_chair
  before_filter :find_user, :except => [:index, :new, :create]
    permitted_to!(:create, User.new(:chair_id => @chair ? @chair.id : nil))
  end
    permitted_to!(:index, :users) if @chair.nil?
    permitted_to!(:chair_manage, @chair) unless @chair.nil?
    true
  end
  layout :choose_layout

  def index
    if @chair.nil?
      @users = User.find(:all, :order => 'last_name')
    else
      @users = @chair.users
    end
  end
  
  def new
    @user = User.new
  end
     
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Информация о пользователе успешно обновлена'
      redirect_to @chair.nil? ? users_path : chair_users_path(@chair)
    else
      render :action => "edit"
    end
  end
 
  def create
    @user = User.new(params[:user])
    unless @chair.nil?      
      @user.chair = @chair
    end
    
    if @user.save
      redirect_to @chair.nil? ? users_path : chair_users_path(@chair)
      flash[:notice] = "Пользователь успешно добавлен"
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "Пользователь успешно удален"
    redirect_to @chair.nil? ? users_path : chair_users_path(@chair)
  end

  private
  
  def find_chair
    @chair = params[:chair_id] ? Chair.find(params[:chair_id]) : nil
  end
  
  def find_user
    @user = User.find(params[:id])
  end
  
  def choose_layout
    @chair.nil? ? 'application' : 'chair'
  end
end
