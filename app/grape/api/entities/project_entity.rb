class API::Entities::ProjectEntity < Grape::Entity
  expose :analysis
  expose :expected_results
  expose :featutes
  expose :forecast
  expose :funds_required
  expose :funds_sources
  expose :goal
  expose :id
  expose :novelty
  expose :purpose
  expose :release_cost
  expose :source_data
  expose :stakeholders
  expose :theme_id
  expose(:participants) { |project, options| API::Entities::ParticipantEntity.represent project.participants }
  expose :title
end
