class Game < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :winner, class_name: 'User', optional: true

  has_many :cells
  has_many :steps
  has_many :gamers

  aasm column: :state do
    state :started, initial: true
    state :finished
  end
end
