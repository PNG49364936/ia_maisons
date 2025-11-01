Rails.application.routes.draw do
  root "predictions#predict"  # page principale

  post "/predict", to: "predictions#predict"
  get  "/predict", to: "predictions#predict"
  get "home", to: "pages#home"



  resources :training_data, only: [:create]
end

