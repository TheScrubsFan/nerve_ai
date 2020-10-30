class GamesController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    game = Game.create!(
      user: current_user,
      dimension: 10
    )

    dimension_params = [].tap do |array|
      (1..game.dimension).each do |y|
        (1..game.dimension).each do |x|
          array << {
            x: x,
            y: y
          }
        end
      end
    end

    game.cells.create(dimension_params)

    render json: { game: game }
  end

  def show
    game = Game.find params[:id]
    gamers = game.gamers

    if !(current_user.in?(gamers.map(&:user))) && gamers.size < 2
      game.gamers.create(user: current_user)
      game.reload
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

    winner = check(game)
    game.update(state: :finished, winner: winner) if winner

    ActionCable.server.broadcast 'game', game: GameSerializer.render_as_hash(game)
  end

  private

  def check(game)
    h = horizontal(game)
    return h if h
    v = vertical(game)
    return v if v

  end

  def horizontal_board(game)
    [].tap do |array|
      (1..game.dimension).each do |y|
        array << game.cells.where(y: y).order('x ASC').map{|c| c.kind? ? c.kind : 'n'}.join('')
      end
    end
  end

  def vertical_board(game)
    [].tap do |array|
      (1..game.dimension).each do |x|
        array << game.cells.where(x: x).order('y ASC').map{|c| c.kind? ? c.kind : 'n'}.join('')
      end
    end
  end

  def horizontal(game)
    board = horizontal_board game

    winner = game.gamers.where.not(kind: nil).detect do |gamer|
      type = gamer.kind.to_s

      win = board.map do |row|
        gamer if row.match(/#{type}{5}/).present?
      end

      win.any?
    end

    if winner
      return winner
    else
      return nil
    end
  end

  def vertical(game)
    board = vertical_board game

    winner = game.gamers.where.not(kind: nil).detect do |gamer|
      type = gamer.kind.to_s

      win = board.map do |row|
        gamer if row.match(/#{type}{5}/).present?
      end

      win.any?
    end

    if winner
      return winner
    else
      return nil
    end
  end
end
