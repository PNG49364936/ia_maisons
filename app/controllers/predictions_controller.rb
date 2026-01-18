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
    @graph_data = {50 => 349_000} if @graph_data.empty?

    # Si aucune taille saisie → on affiche la vue sans calculer
    if params[:taille].blank?
      @resultat = "⚠️ Veuillez entrer une taille avant de prédire."
      return render :predict
    end

    # Taille saisie
    @taille = params[:taille].to_f

    # Données d’entraînement pour le modèle
    if @training_data.count < 2
  @resultat = "⚠️ Il faut au moins 2 appartements enregistrés pour entraîner le modèle."
  return render :predict

    else
      x = Numo::DFloat[*@training_data.map { |d| [d.taille] }]
      y = Numo::DFloat[*@training_data.map(&:prix)]
    end

    # Entraînement du modèle de régression
    model = Rumale::LinearModel::LinearRegression.new
    model.fit(x, y)

    # Prédiction
    @prix_prevu = model.predict(Numo::DFloat[[ @taille ]])[0]

    # Majoration de 10% si bien neuf
    @type_bien = params[:type_bien] || "ancien"
    if @type_bien == "neuf"
      @prix_prevu = @prix_prevu * 1.10
    end

    # Ajustement selon l'état du bien
    @etat_bien = params[:etat_bien] || "bon_etat"
    @ajustement_etat = nil
    if @type_bien == "ancien"
      case @etat_bien
      when "a_renover"
        @prix_prevu = @prix_prevu * 0.85
        @ajustement_etat = "-15%"
      when "bon_etat"
        @prix_prevu = @prix_prevu * 0.95
        @ajustement_etat = "-5%"
      when "totalement_renove"
        @prix_prevu = @prix_prevu * 1.15
        @ajustement_etat = "+15%"
      end
    elsif @type_bien == "neuf"
      case @etat_bien
      when "a_renover"
        @prix_prevu = @prix_prevu * 0.90
        @ajustement_etat = "-10%"
      when "bon_etat"
        # Pas de modification
        @ajustement_etat = nil
      when "totalement_renove"
        @prix_prevu = @prix_prevu * 1.10
        @ajustement_etat = "+10%"
      end
    end

    @resultat = "Prix estimé : #{@prix_prevu.round(2)} €"
    @resultat += " (neuf +10%)" if @type_bien == "neuf"
    @resultat += " (#{@etat_bien.gsub('_', ' ')} #{@ajustement_etat})" if @ajustement_etat
    puts "DEBUG >> @taille = #{@taille}, @prix_prevu = #{@prix_prevu}, @type_bien = #{@type_bien}"

    render :predict
  end
end

