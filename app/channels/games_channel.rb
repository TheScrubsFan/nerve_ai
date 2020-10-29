class GamesChannel < ApplicationCable::Channel
  def subscribed
    #game = Game.find params[:id]

    stream_from 'game'
    #stream_from 'ola'
  end
end
