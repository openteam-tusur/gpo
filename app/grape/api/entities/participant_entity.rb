class API::Entities::ParticipantEntity < Grape::Entity
  expose :first_name
  expose :last_name
  expose :mid_name
end
