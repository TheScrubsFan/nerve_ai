class Gamer < ApplicationRecord
  extend Enumerize

  belongs_to :game
  belongs_to :user

  enumerize :kind, in: [:x, :o]
end
