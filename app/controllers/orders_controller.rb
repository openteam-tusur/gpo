class OrdersController < ApplicationController
  before_filter :find_chair_and_project
  before_filter :find_order, :except => [:index, :new, :create]
  before_filter :prepare_order, :only => [:new, :create]
  layout 'chair'
  filter_access_to [:index, :show] do
    permitted_to!(:read, @project) if @project
    permitted_to!(:read, @chair) unless @project
    true
  end
  filter_access_to [:new, :create], :require => :create, :attribute_check => true
  filter_access_to [:edit, :update], :require => :update, :attribute_check => true
  filter_access_to :destroy, :require => :delete, :attribute_check => true

  def index
    unless @project.nil?
      render :template => "orders/project_orders", :layout => "project"
      return
    end
    @orders = @chair.orders.find(:all)
  end

  def show
#    authorize can_view?(@order)
    respond_to do |format|
      format.html { render :layout => 'order' }
      format.odt { send_odt } if params[:format] == 'odt'
      format.doc { send_converted_odt(:doc) } if params[:format] == 'doc'
    end
  end

  def new
#    authorize can_create?(@order, @chair)
  end

  def create
#    authorize can_create?(@order, @chair)
    @order.update_projects(params[:projects])

    if @order.save
      flash[:notice] = 'Приказ успешно создан'
      redirect_to(chair_order_url(@chair, @order))
    else
      render :action => "new", :type => @order.class.name
    end
  end

  def edit
#    authorize can_update?(@order)
  end

  def update
#    authorize can_update?(@order, @chair)
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
 #     authorize @order.can_send_to_review?(current_user)
      if @order.to_review
        flash[:notice] = "Приказ отправлен на визирование"
        @order.activity!("to_review", current_user.name, params[:comment])
      end
      redirect_to chair_order_url(@order.chair, @order)
    end
    unless params[:review].blank?
      permitted_to!(:review, @order)
  #    authorize @order.can_send_review?(current_user)
      if @order.review
        flash[:notice] = "Приказ визирован"
        @order.activity!("review", current_user.name, params[:comment])
      end
      redirect_to chair_order_url(@order.chair, @order)
    end
    unless params[:cancel].blank?
      permitted_to!(:cancel, @order)
   #   authorize @order.can_send_cancel?(current_user)
      if @order.cancel
        flash[:notice] = "Приказ возвращён на доработку"
        @order.activity!("return", current_user.name, params[:comment])
      end
      redirect_to chair_order_url(@order.chair, @order)
    end
    unless params[:approve].blank?
      permitted_to!(:approve, @order)
    #  authorize @order.can_send_approve?(current_user)
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
#    authorize can_destroy?(@order)
    
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
    send_file @order.file.to_file.path, :type => Mime::Type.lookup_by_extension('odt'), :filename => @order.file_file_name
  end

  def send_converted_odt(format)
    filename = "order_#{@order.id}.#{format.to_s}"
    converted_file = Tempfile.new('converted_file')
    system("bash", "#{RAILS_ROOT}/script/converter/converter.sh", @order.file.to_file.path, converted_file.path, format.to_s)
    send_file converted_file.path, :type => Mime::Type.lookup_by_extension(format.to_s), :filename => filename
    converted_file.close
  end
end
