class WorldInventoryController < ApplicationController
  before_action :set_world

  private
  def set_world
    @world = World.find_by(slug: params[:world_slug])
    require_permissons
  end

  # FIXME: This should once be replaced by pundit
  def require_permissons
    unless current_user == @world.user
      flash[:alert] = "You are not allowed to create s.th. in this world"
      redirect_to worlds_path
    end
  end
end
