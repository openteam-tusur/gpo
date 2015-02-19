# encoding: utf-8

class Manage::ParticipantsController < Manage::InheritedResourcesController
  belongs_to :chair, :parent_class => Chair do
    belongs_to :project
  end

  actions :index, :new, :create, :edit, :update
  custom_actions :resource => [:make_executive, :unmake_executive]

  helper_method :finded_participants

  layout :resolve_layout

  def make_executive
    make_executive!{
      if @project.participants.as_executive.any?
        Permission.where(:context_id => @project.id, :context_type => 'Project', :role => 'executive_participant').destroy_all
        @project.participants.as_executive.first.update_attribute(:executive, false)
      end
      @participant.update_attribute(:executive, true)

      redirect_to manage_chair_project_participants_path(@chair, @project) and return
    }
  end

  def unmake_executive
    unmake_executive! {
      @participant.update_attribute(:executive, false)

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
