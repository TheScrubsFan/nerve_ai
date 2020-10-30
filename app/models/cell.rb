class Cell < ApplicationRecord
  extend Enumerize

  belongs_to :game

  enumerize :kind, in: [:x, :o]
end
