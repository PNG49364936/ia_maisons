class CreateTrainingData < ActiveRecord::Migration[7.1]
  def change
    create_table :training_data do |t|
      t.float :taille
      t.float :prix

      t.timestamps
    end
  end
end
