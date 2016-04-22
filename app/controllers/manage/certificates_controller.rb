class Manage::CertificatesController < Manage::ApplicationController
  before_action :find_chair
  before_action :find_certificate, except: [:index, :create]

  load_and_authorize_resource

  layout 'chair'

  def index
    @participants = Participant.active.joins(:project)
                      .where("projects.id in (?)", Project.for_user(current_user).pluck(:id))
    @certificates = Certificate.joins(:participant)
                      .where("participants.id in (?)", @participants.pluck(:id) )
                      .map{|c| extended_json(c)}
                      .to_json
    # raise @certificates.inspect
  end

  def create
    @certificate = Certificate.new params[:certificate].merge(user_id: current_user.id)
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

  private

  def extended_json(ar_object)
    hash = ar_object.as_json(to_json_defaults)
    hash[:abilities] = check_abilities(ar_object)
    hash
  end

  def check_abilities(ar_object)
      {
        edit_destroy: can?(:crud, ar_object),
        approve: can?(:approve, ar_object),
        decline: can?(:decline, ar_object),
        edit_participant: can?(:crud, ar_object) && ar_object.user.id == current_user.id
      }
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
          methods: [:name, :text_for_views]
        }
      },
      methods: [:state_text]
    }
  end

  def find_chair
    @chair = Chair.find(params[:chair_id])
  end

  def find_certificate
    @certificate = Certificate.find params[:id]
  end
end
