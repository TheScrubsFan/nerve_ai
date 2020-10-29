class GamesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game'
  end
end
