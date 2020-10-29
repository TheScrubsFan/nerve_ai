class Step < ApplicationRecord
  belongs_to :game
  belongs_to :gamer
  belongs_to :cell
end
