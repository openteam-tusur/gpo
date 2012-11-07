class API::Entities::ParticipantEntity < Grape::Entity
  expose :course
  expose :edu_group
  expose :email
  expose :first_name
  expose :id
  expose :last_name
  expose :mid_name
end
