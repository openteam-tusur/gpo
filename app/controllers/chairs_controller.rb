class ChairsController < ApplicationController
  before_filter :find_chair, :except => [:index, :new, :create]
  filter_access_to :index, :require => :read
  filter_access_to [:show, :managers], :require => :read, :attribute_check => true
  filter_access_to [:edit, :update], :require => :update, :attribute_check => true
  filter_access_to [:new, :create, :destroy], :require => :manage

  def index
    @chairs = Chair.find(:all, :order => "abbr")
    redirect_to chair_url(params[:go_to_chair]) if params[:go_to_chair]
  end

  def show
    render :layout => 'chair'
  end

  def new
    @chair = Chair.new
  end

  def edit
  end

  def create
    @chair = Chair.new(params[:chair])
    
    if @chair.save
      flash[:notice] = 'Кафедра успешно добавлена'
      redirect_to(@chair)
    else
      render :action => "new"
    end
  end

  def update

    if @chair.update_attributes(params[:chair])
      flash[:notice] = 'Информация о кафедре успешно обновлена'
      redirect_to(@chair)
    else
      render :action => "edit"
    end
  end
  
  def managers
    render :layout => 'chair'
  end

  def destroy
    @chair.destroy
    redirect_to(chairs_url)
  end
  
  protected
  def find_chair
    @chair = Chair.find(params[:id])
  end
end
