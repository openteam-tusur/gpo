class API::Entities::ProjectManagerEntity < Grape::Entity
  expose :first_name,   :format_with => ->(s) { s.squish }
  expose :last_name,    :format_with => ->(s) { s.squish }
  expose :middle_name,  :format_with => ->(s) { s.squish }
end
