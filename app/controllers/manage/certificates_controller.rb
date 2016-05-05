class Manage::CertificatesController < Manage::ApplicationController
  before_action :find_chair
  before_action :find_certificate, except: [:index, :create, :pdf_all]

  load_and_authorize_resource

  layout :resolve_layout

  def index
    check_request_and_permission

    @participants = Participant.active.joins(:project)
                      .where("projects.id in (?)", Project.for_user(current_user).pluck(:id))
    @certificates = Certificate.send(scope_for_role).joins(:participant)
                      .where("participants.id in (?)", @participants.pluck(:id) )
                      .map{|c| extended_json(c)}
                      .to_json
    @filters = resolve_filter
  end

  def create
    @certificate = Certificate.new params[:certificate].merge(user_id: current_user.id, state: resolve_state)
    respond if @certificate.save
  end

  def update
    respond if @certificate.update(params[:certificate])
  end

  def destroy
    @certificate.destroy
    render json: '200'
  end

  def approve
    respond if @certificate.approve
  end

  def decline
    respond if @certificate.decline
  end

  def pdf
    pdf = CertificatePdf.new([@certificate])
    send_data pdf.make_pdf, filename: "certificate.pdf", type: "application/pdf" and return
  end

  def pdf_all
    @certificates = Certificate.where(id: params[:certificates])
    pdf = CertificatePdf.new(@certificates)
    send_data pdf.make_pdf, filename: "certificate.pdf", type: "application/pdf" and return
  end

  private

  def extended_json(ar_object)
    hash = ar_object.as_json(to_json_defaults)
    hash[:abilities] = check_abilities(ar_object)
    hash
  end

  def check_abilities(ar_object)
    if current_user.manager?
      {
        edit_destroy: true,
        approve:  ar_object.send_to_manager?,
        decline:  ar_object.send_to_manager? || ar_object.published?,
        edit_participant: ar_object.send_to_manager? && ar_object.user.id == current_user.id,
        pdf: ar_object.published?
      }
    else
      {
        edit_destroy: can?(:crud, ar_object),
        approve: can?(:approve, ar_object),
        decline: can?(:decline, ar_object),
        edit_participant: can?(:crud, ar_object) && ar_object.user.id == current_user.id,
        pdf: can?(:export_pdf, ar_object)
      }
    end
  end

  def respond
    respond_to do |format|
      format.json{ render json: extended_json(@certificate) }
    end
  end


  def to_json_defaults
    {
      include: {
        participant:
        {
          only: [:id],
          methods: [:name, :text_for_views, :project_to_s]
        }
      },
      methods: [:state_text]
    }
  end

  def find_chair
    @chair = Chair.find(params[:chair_id]) if params[:chair_id]
  end

  def find_certificate
    @certificate = Certificate.find params[:id]
  end

  def resolve_layout
    params[:chair_id] ? 'chair' : 'application'
  end

  def scope_for_role
    return 'all' if current_user.project_manager?
    return 'for_mentor' if current_user.mentor?
    return 'for_manager' if current_user.manager?
  end

  def check_request_and_permission
    redirect_to manage_root_path if !request.path.match(/chair/) && !current_user.manager?
  end

  def resolve_state
    current_user.mentor? ? 'send_to_mentor' : 'initialized'
  end

  def resolve_filter
    array_states = if current_user.mentor?
      %w(send_to_mentor published)
    elsif current_user.manager?
      %w(send_to_manager published)
    else
      %w(initialized send_to_mentor send_to_manager published)
    end

    array_states.map do |state|
      {
        state: state,
        text: I18n.t("activerecord.state_machines.certificate.state.#{state}")
      }
    end
  end
end
