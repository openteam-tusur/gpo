class API::Entities::ManagerEntity < Grape::Entity
  expose :id
  expose :project_id
  expose :email
  expose :first_name
  expose :last_name
  expose :mid_name
  expose :chair_id
end
