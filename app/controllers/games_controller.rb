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

  def show
    game = Game.find params[:id]

    if !current_user.in?(game.gamers.map(&:user)) && game.gamers.size < 2
      game.gamers.create(user: current_user)
      ActionCable.server.broadcast 'game', game: GameSerializer.render_as_hash(game)
    end

    render json: GameSerializer.render_as_hash(game)
  end

  def make_step
    game = Game.find params[:id]
    gamer = game.gamers.find_by(user_id: current_user.id)
    cell = Cell.find(params[:cell][:id])

    kind = game.steps.any? ? :o : :x
    gamer.update(kind: kind) unless gamer.kind

    game.steps.create(
      cell_id: cell.id,
      gamer_id: gamer.id
    )
    cell.update(kind: gamer.kind)

    ActionCable.server.broadcast 'game', game: GameSerializer.render_as_hash(game)
  end
end
