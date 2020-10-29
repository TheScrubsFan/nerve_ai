class GamesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    game = Game.create!(
      user: current_user,
      dimension: 10
    )

    (1..game.dimension).each do |y|
      (1..game.dimension).each do |x|
        game.cells.create(x: x, y: y)
      end
    end

    render json: { game: game }
  end
end
