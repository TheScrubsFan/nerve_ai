class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps do |t|
      t.references :game, null: false, foreign_key: true
      t.references :gamer, null: false, foreign_key: true
      t.references :cell, null: false, foreign_key: true

      t.timestamps
    end
  end
end
