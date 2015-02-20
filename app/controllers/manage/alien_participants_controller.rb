class Manage::AlienParticipantsController < Manage::InheritedResourcesController
  belongs_to :chair, :parent_class => Chair do
    belongs_to :project
  end

  actions :new, :create, :update

  layout :resolve_layout

  private

  def parent_url
    manage_chair_project_participants_path(@chair, @project)
  end

  def resolve_layout
    return false if ['edit', 'update', 'show'].include?(action_name)

    'project'
  end
end
