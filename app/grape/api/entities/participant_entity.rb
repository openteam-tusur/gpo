class API::Entities::ParticipantEntity < Grape::Entity
  expose :name,   :format_with => ->(s) { s.try(:squish) }
  expose :edu_group
end
