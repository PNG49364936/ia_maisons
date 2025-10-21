class TrainingDataController < ApplicationController
  def create
    @training_datum = TrainingDatum.new(training_data_params)
    if @training_datum.save
      redirect_to root_path, notice: "✅ Nouvelle donnée réelle ajoutée !"
    else
      redirect_to root_path, alert: "⚠️ Impossible d’ajouter cette donnée."
    end
  end

  private

  def training_data_params
    params.require(:training_datum).permit(:taille, :prix)
  end
end


