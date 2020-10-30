class UsersController < ApplicationController
  before_action :authenticate_user!

  def current
    render json: { user: UserSerializer.render_as_hash(current_user) }
  end
end
