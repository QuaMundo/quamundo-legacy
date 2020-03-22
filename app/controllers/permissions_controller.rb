class PermissionsController < ApplicationController
  rescue_from ActionPolicy::Unauthorized do |ex|
    # FIXME: Manage err msgs
    flash[:alert] = t('.not_allowed', world: @world.name)
    # flash[:alert] = ex.result.reasons.full_messages
    redirect_to worlds_path
  end

  before_action :set_world

  authorize :world, through: :current_world

  def edit
  end

  private
  # FIXME: This has to be changed if in future releases other objects
  # should be permittable, too.
  def set_world
    @world = World
      .includes(permissions: [:user])
      .find_by(slug: params[:world_slug])
    authorize! @world.permissions
  end

  def current_world
    @world
  end
end
