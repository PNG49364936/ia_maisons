class TrainingDataController < ApplicationController
  def create
    TrainingDatum.create(training_data_params)
    redirect_to root_path, notice: "Nouvelle donnée réelle ajoutée !"
  end

  private

  def training_data_params
    params.require(:training_datum).permit(:taille, :prix)
  end
end



