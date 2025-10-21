Rails.application.routes.draw do
  root "predictions#predict"
  post "/predict", to: "predictions#predict"

  # Route REST standard pour créer des données d'entraînement
  resources :training_data, only: [:create]
end
