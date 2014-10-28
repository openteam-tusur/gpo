class API::Entities::ProjectManagerEntity < Grape::Entity
  expose :name,   :format_with => ->(s) { s.try(:squish) }
  expose :surname,    :format_with => ->(s) { s.try(:squish) }
  expose :patronymic,  :format_with => ->(s) { s.try(:squish) }
end
