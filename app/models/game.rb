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

  def current_gamer
    return user if steps.blank?

    last_gamer = steps.order('created_at ASC').last.gamer

    gamers.where.not(id: last_gamer.id).first
  end
end
