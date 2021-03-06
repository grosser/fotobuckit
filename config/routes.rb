Fotobuckit::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  match 'login' => 'sessions#new'
  match 'logout' => 'sessions#destroy'
  match 'signup' => 'users#new'
  match 'account' => 'users#edit'
  match 'image/resize/:data' => 'image#resize'

  resources :jobs do
    collection do
      get :iframe
    end
    member do
      get :access
    end
  end
  resources :users do
    collection do
      get :sync
    end
  end
  resources :sessions

  match "home(/:action/(:id))", :controller => :home

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
