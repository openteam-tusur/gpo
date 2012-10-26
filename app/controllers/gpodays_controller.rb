# encoding: utf-8

class GpodaysController < ApplicationController

  # GET /gpodays
  # GET /gpodays.xml
  def index
    @gpodays = Gpoday.find(:all, :order => "date DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gpodays }
    end
  end

  # GET /gpodays/new
  # GET /gpodays/new.xml
  def new
    @gpoday = Gpoday.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gpoday }
    end
  end

  # GET /gpodays/1/edit
  def edit
    @gpoday = Gpoday.find(params[:id])
  end

  # POST /gpodays
  # POST /gpodays.xml
  def create
    @gpoday = Gpoday.new(params[:gpoday])

    respond_to do |format|
      if @gpoday.save
        flash[:notice] = 'День ГПО добавлен в расписание'
        format.html { redirect_to gpodays_path }
        format.xml  { render :xml => @gpoday, :status => :created, :location => @gpoday }
      else
        flash[:error] = 'Ошибка добавления дня ГПО в расписание'
        format.html { render :action => "new" }
        format.xml  { render :xml => @gpoday.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gpodays/1
  # PUT /gpodays/1.xml
  def update
    @gpoday = Gpoday.find(params[:id])

    respond_to do |format|
      if @gpoday.update_attributes(params[:gpoday])
        flash[:notice] = 'День ГПО сохранен'
        format.html { redirect_to gpodays_path }
        format.xml  { head :ok }
      else
        flash[:error] = 'Ошибка сохранения дня ГПО'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gpoday.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gpodays/1
  # DELETE /gpodays/1.xml
  def destroy
    @gpoday = Gpoday.find(params[:id])
    @gpoday.destroy
    flash[:notice] = 'День ГПО удален из расписания'
    respond_to do |format|
      format.html { redirect_to(gpodays_path) }
      format.xml  { head :ok }
    end
  end
end

