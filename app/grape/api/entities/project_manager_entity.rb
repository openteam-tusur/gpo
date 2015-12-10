class API::Entities::ProjectManagerEntity < Grape::Entity
  expose :to_s, :as => :name
end
