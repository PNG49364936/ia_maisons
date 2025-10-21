class PredictionsController < ApplicationController
  require 'rumale'

  def index
    @training_data = TrainingDatum.all
  end

  def predict
  if params[:taille].blank?
    @resultat = "⚠️ Veuillez entrer une taille avant de prédire."
    @training_data = TrainingDatum.all
    @graph_data = @training_data.map { |d| [d.taille, d.prix] }.to_h
    return render :predict
  end

  taille = params[:taille].to_f

  # Charger les données d'entraînement depuis la base
  training_data = TrainingDatum.all
  if training_data.empty?
    x = Numo::DFloat[[50],[55],[60],[65],[70],[75],[80],[85],[90],[95],[100]]
    y = Numo::DFloat[100_000,110_000,120_000,130_000,140_000,150_000,158_000,150_000,180_000,185_000,192_000]
  else
    x = Numo::DFloat[*training_data.map { |d| [d.taille] }]
    y = Numo::DFloat[*training_data.map(&:prix)]
  end

  # Entraînement du modèle
  model = Rumale::LinearModel::LinearRegression.new
  model.fit(x, y)

  # Prédiction
  nouvelle_donnee = Numo::DFloat[[taille]]
  prix_prevu = model.predict(nouvelle_donnee)[0]

  @resultat = "Prix estimé : #{prix_prevu.round(2)} €"
  @training_data = training_data

  # 🟩 Construire les données pour le graphe
  @graph_data = @training_data.map { |d| [d.taille, d.prix] }.to_h
  @graph_data = {50 => 100000, 60 => 120000, 70 => 150000} if @graph_data.empty?

  render :predict
end


end

