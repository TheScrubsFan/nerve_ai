class Cell < ApplicationRecord
  extend Enumerize

  belongs_to :game

  enumerize :type, in: [:x, :o]
end
