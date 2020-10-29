class Gamer < ApplicationRecord
  extend Enumerize

  belongs_to :game
  belongs_to :user

  enumerize :type, in: [:x, :o]
end
