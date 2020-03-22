Rails.application.routes.draw do
  # FIXME: new/create should be removed, since only admin is allowed to
  devise_for(
    :users,
    skip: [:registrations],
    controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }
  )
  as :user do
    get 'users/edit' => 'users/registrations#edit',
      as: 'edit_user_registration'
    put 'users' => 'users/registrations#update',
      as: 'user_registration'
    patch 'users' => 'users/registrations#update'
    delete 'users' => 'users/registrations#destroy'
  end

  resources :users, only: [:index, :new, :create]

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
      # relations
      resources :relations
    end

    resource :permissions, only: [:edit]
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "dashboard#index"
end
