# encoding: utf-8

class OrdersController < ApplicationController
  before_filter :find_chair_and_project
  before_filter :find_order, :except => [:index, :new, :create]
  before_filter :prepare_order, :only => [:new, :create]
  layout 'chair'
    permitted_to!(:read, @project) if @project
    permitted_to!(:read, @chair) unless @project
    true
  end

  def index
    unless @project.nil?
      render :template => "orders/project_orders", :layout => "project"
      return
    end
    @orders = @chair.orders.find(:all)
  end

  def show
    respond_to do |format|
      format.html { render :layout => 'order' }
      format.odt { send_odt } if params[:format] == 'odt'
      format.doc { send_converted_odt(:doc) } if params[:format] == 'doc'
    end
  end

  def new
  end

  def create
    @order.update_projects(params[:projects])

    if @order.save
      flash[:notice] = 'Приказ успешно создан'
      redirect_to(chair_order_url(@chair, @order))
    else
      render :action => "new", :type => @order.class.name
    end
  end

  def edit
  end

  def update
    @order.update_projects(params[:projects]) unless @order.approved?

    if @order.update_attributes(params[:order])
      flash[:notice] = 'Приказ успешно сохранен'
      redirect_to chair_order_url(@order.chair, @order)
    else
      render :action => "edit"
    end
  end

  def update_state
    unless params[:to_review].blank?
      permitted_to!(:to_review, @order)
      if @order.to_review
        flash[:notice] = "Приказ отправлен на визирование"
        @order.activity!("to_review", current_user.name, params[:comment])
      end
      redirect_to chair_order_url(@order.chair, @order)
    end
    unless params[:review].blank?
      permitted_to!(:review, @order)
      if @order.review
        flash[:notice] = "Приказ визирован"
        @order.activity!("review", current_user.name, params[:comment])
      end
      redirect_to chair_order_url(@order.chair, @order)
    end
    unless params[:cancel].blank?
      permitted_to!(:cancel, @order)
      if @order.cancel
        flash[:notice] = "Приказ возвращён на доработку"
        @order.activity!("return", current_user.name, params[:comment])
      end
      redirect_to chair_order_url(@order.chair, @order)
    end
    unless params[:approve].blank?
      permitted_to!(:approve, @order)
      begin
        @order.state = 'approved'
        @order.update_attributes!(params[:order])
        flash[:notice] = "Приказ утвержден"
        @order.activity!("approve", current_user.name, params[:comment])
        redirect_to chair_order_url(@order.chair, @order)
      rescue
        @order.state = @order.state_was
        render :action => :show
      end
    end
  end

  def destroy
    @order.remove
    flash[:notice] = 'Приказ успешно удален'
    redirect_to chair_orders_url(@chair)
  end

  protected
  def find_chair_and_project
    @chair = Chair.find(params[:chair_id])
    @project = Project.find_by_id(params[:project_id])
  end

  def find_order
    @order = @chair.orders.find(params[:id])
  end

  def prepare_order
    @order = @chair.build_order(params[:type], params[:order])
  end

  def send_odt
    filename = "order_#{@order.id}.odt"
    if @order.file?
      send_file @order.file.to_file.path, :type => Mime::Type.lookup_by_extension('odt'), :filename => filename
    else
      @order.generate_odt_file do |file|
        send_file file.path, :type => Mime::Type.lookup_by_extension('odt'), :filename => filename
      end
    end
  end

  def send_converted_odt(format)
    filename = "order_#{@order.id}.#{format.to_s}"
    converted_file = Tempfile.new('converted_file')
    if @order.file?
      system("bash", "#{RAILS_ROOT}/script/converter/converter.sh", @order.file.to_file.path, converted_file.path, format.to_s)
      send_file converted_file.path, :type => Mime::Type.lookup_by_extension(format.to_s), :filename => filename
      converted_file.close
    else
      @order.generate_odt_file do |file|
        system("bash", "#{RAILS_ROOT}/script/converter/converter.sh", file.path, converted_file.path, format.to_s)
        send_file converted_file.path, :type => Mime::Type.lookup_by_extension(format.to_s), :filename => filename
        converted_file.close
      end
    end
  end
end
