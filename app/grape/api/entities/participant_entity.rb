class API::Entities::ParticipantEntity < Grape::Entity
  expose :course
  expose :edu_group
  expose :first_name
  expose :last_name
  expose :mid_name
end