class API::Gpo < Grape::API
  prefix :api
  format :json

  helpers do
    def chairs
      @chairs ||= Chair.all
    end

    def themes
      @themes ||= Theme.all
    end
  end

  resources :chairs do
    desc 'Returns chairs'
    get do
      present chairs, with: API::Entities::ChairEntity
    end
  end

  resources :themes do
    desc 'Returns themes'
    get do
      present themes, with: API::Entities::ThemeEntity
    end
  end
end
