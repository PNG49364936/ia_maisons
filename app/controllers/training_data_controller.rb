class TrainingDataController < ApplicationController
  def new
    @training_datum = TrainingDatum.new
    @training_data = TrainingDatum.all  # 👈 ajoute cette ligne
  end

  def create
    @training_datum = TrainingDatum.new(training_data_params)
    if @training_datum.save
      redirect_to root_path, notice: "Nouvelle donnée réelle ajoutée !"
    else
      @training_data = TrainingDatum.all
      render :new, status: :unprocessable_entity
    end
  end

  private

  def training_data_params
    params.require(:training_datum).permit(:taille, :prix)
  end
end




