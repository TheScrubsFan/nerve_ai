class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :winner_id
      t.string :state
      t.integer :dimension

      t.timestamps
    end
  end
end
