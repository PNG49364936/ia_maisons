class PredictionsController < ApplicationController
  require 'rumale'

  def index
    redirect_to action: :predict
  end

  def predict
    # Récupère toutes les données d'entraînement
    @training_data = TrainingDatum.all

    # Prépare les données pour le graphe
    @graph_data = @training_data.map { |d| [d.taille, d.prix] }.to_h
    @graph_data = {50 => 100_000, 60 => 120_000, 70 => 150_000} if @graph_data.empty?

    # Si aucune taille saisie → on affiche la vue sans calculer
    if params[:taille].blank?
      @resultat = "⚠️ Veuillez entrer une taille avant de prédire."
      return render :predict
    end

    # Taille saisie
    @taille = params[:taille].to_f

    # Données d’entraînement pour le modèle
    if @training_data.empty?
      x = Numo::DFloat[[50]]
      y = Numo::DFloat[341_000]
    else
      x = Numo::DFloat[*@training_data.map { |d| [d.taille] }]
      y = Numo::DFloat[*@training_data.map(&:prix)]
    end

    # Entraînement du modèle de régression
    model = Rumale::LinearModel::LinearRegression.new
    model.fit(x, y)

    # Prédiction
    @prix_prevu = model.predict(Numo::DFloat[[ @taille ]])[0]
    @resultat = "Prix estimé : #{@prix_prevu.round(2)} €"
    puts "DEBUG >> @taille = #{@taille}, @prix_prevu = #{@prix_prevu}"

    render :predict
  end
end

