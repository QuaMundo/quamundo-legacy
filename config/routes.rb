Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # World#index and World#create via get/post '/worlds'
  resources :worlds, only: [:index, :create]

  concern :noteable do
    resources :notes, shallow: true, except: [:index, :show]
  end

  concern :dossierable do
    resources :dossiers, shallow: true, except: [:index]
  end

  # Since World is the 'root container' world_slug should be top level part
  # of a path, example:
  # World with slug 'my_world' should be reached via '/my_world'
  resources :worlds, param: :slug, path: '/', except: [:index, :create],
    concerns: [:noteable, :dossierable] do

    resources :concepts, :figures, :items, :locations, :facts do
      concerns :noteable
      concerns :dossierable
    end

    resources :facts do
      # fact_constituents
      resources :fact_constituents, except: [:show, :index]
      # relations
      resources :relations
    end

    resources :relation_constituents, except: [:index, :show]
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "dashboard#index"
end
