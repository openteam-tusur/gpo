class API::Entities::ProjectManagerEntity < Grape::Entity
  expose :fullname,   :format_with => ->(s) { s.try(:squish) }
end
