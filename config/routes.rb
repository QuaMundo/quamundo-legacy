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

  concern :tagable do
    resources :tags, shallow: true, except: [:new, :create, :show, :index]
  end

  concern :traitable do
    resources :traits, shallow: true, except: [:new, :create, :show, :index]
  end

  # Since World is the 'root container' world_slug should be top level part
  # of a path, example:
  # World with slug 'my_world' should be reached via '/my_world'
  resources :worlds,
    param: :slug,
    path: '/',
    except: [:index, :create],
    concerns: [:noteable, :tagable, :traitable, :dossierable] do

      resources :figures, :items, :locations do
        concerns :noteable
        concerns :dossierable
        concerns :tagable
        concerns :traitable
      end
    end

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root to: "dashboard#index"
end
