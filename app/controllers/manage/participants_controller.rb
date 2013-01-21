# encoding: utf-8

class Manage::ParticipantsController < Manage::InheritedResourcesController
  belongs_to :chair, :project

  actions :index, :new, :create, :edit, :update

  helper_method :finded_participants

  layout :resolve_layout

  private

  def finded_participants
    @finded_participants ||= Participant.contingent_find_for_manage(params)
  end

  def resolve_layout
    return false if ['edit', 'update', 'show'].include?(action_name)

    'project'
  end
end
