class GamesChannel < ApplicationCable::Channel
  def subscribed
    stream_from(params[:room])
  end
end
