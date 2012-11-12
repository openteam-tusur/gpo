class API::Entities::ProjectEntity < Grape::Entity
  expose :chair_id
  expose :id
  expose :theme_id
  expose :title

  expose :analysis,         if: ->(project, options) { !!options[:full] }
  expose :expected_results, if: ->(project, options) { !!options[:full] }
  expose :featutes,         if: ->(project, options) { !!options[:full] }
  expose :forecast,         if: ->(project, options) { !!options[:full] }
  expose :funds_required,   if: ->(project, options) { !!options[:full] }
  expose :funds_sources,    if: ->(project, options) { !!options[:full] }
  expose :goal,             if: ->(project, options) { !!options[:full] }
  expose :novelty,          if: ->(project, options) { !!options[:full] }
  expose :purpose,          if: ->(project, options) { !!options[:full] }
  expose :release_cost,     if: ->(project, options) { !!options[:full] }
  expose :source_data,      if: ->(project, options) { !!options[:full] }
  expose :stakeholders,     if: ->(project, options) { !!options[:full] }

  expose(:participants)     { |project, options| API::Entities::ParticipantEntity.represent project.participants if !!options[:full] }
  expose(:project_managers) { |project, options| API::Entities::ProjectManagerEntity.represent project.project_managers if !!options[:full] }
end
