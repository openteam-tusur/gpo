# encoding: utf-8

class Manage::ParticipantsController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair do
    belongs_to :project
  end

  actions :all, :except => :show

  helper_method :finded_participants

  layout 'project'

  private

  def finded_participants
    @finded_participants ||= Participant.contingent_find(params[:search] || {})
  end

end
