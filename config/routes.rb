Rails.application.routes.draw do
 
  root to: 'pages#home'

  post "/predict", to: "predictions#predict"
  get  "/predict", to: "predictions#predict"
  get "home", to: "pages#home"
    



  resources :training_data, only: [:new, :create]
resources :predictions do
  collection do
    get :predict
     post :predict 
  end
end

end

