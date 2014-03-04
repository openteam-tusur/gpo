# encoding: utf-8

class Manage::ParticipantsController < Manage::InheritedResourcesController
  belongs_to :chair, :project

  actions :index, :new, :create, :edit, :update
  custom_actions :resource => :make_executive

  helper_method :finded_participants

  layout :resolve_layout

  def make_executive
    make_executive!{
      @project.participants.as_executive.first.update_attribute(:executive, false) if @project.participants.as_executive.any?
      @participant.update_attribute(:executive, true)

      redirect_to manage_chair_project_participants_path(@chair, @project) and return
    }
  end

  private

  def finded_participants
    @finded_participants ||= Participant.contingent_find_for_manage(params)
  end

  def resolve_layout
    return false if ['edit', 'update', 'show'].include?(action_name)

    'project'
  end
end
