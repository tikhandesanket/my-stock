Rails.application.routes.draw do
  resources :items
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :items do
    collection { post :import}
  end

  get "/upload", to: "items#upload"

  # default url
  root 'items#index'
end
