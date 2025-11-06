class TrainingDataController < ApplicationController
  def new
    @training_datum = TrainingDatum.new
    @training_data = TrainingDatum.all  # 👈 ajoute cette ligne
  end

  def create
    @training_datum = TrainingDatum.new(training_data_params)
    if @training_datum.save
       flash.now[:notice] = "Nouvelle donnée réelle ajoutée !"
      @training_data = TrainingDatum.all
      render :new, status: :ok
    else
      @training_data = TrainingDatum.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def training_data_params
    params.permit(:taille, :prix)
  end
end




