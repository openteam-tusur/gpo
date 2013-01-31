class API::Entities::ProjectEntity < Grape::Entity
  expose :chair_id
  expose :cipher
  expose :id
  expose :theme_id
  expose :title

  expose :analysis,         if: {extra: true}
  expose :expected_results, if: {extra: true}
  expose :featutes,         if: {extra: true}
  expose :forecast,         if: {extra: true}
  expose :funds_required,   if: {extra: true}
  expose :funds_sources,    if: {extra: true}
  expose :goal,             if: {extra: true}
  expose :novelty,          if: {extra: true}
  expose :purpose,          if: {extra: true}
  expose :release_cost,     if: {extra: true}
  expose :source_data,      if: {extra: true}
  expose :stakeholders,     if: {extra: true}

  expose(:participants,     if: {participants: true}) { |project, options| API::Entities::ParticipantEntity.represent project.participants }
  expose(:managers,         if: {participants: true}) { |project, options| API::Entities::ProjectManagerEntity.represent project.project_managers }

  expose(:url,              if: {url: true})          { |project, options| "http://gpo.tusur.ru/chairs/#{project.chair_id}/projects/#{project.id}" }
end
