module WorldAssociationController
  extend ActiveSupport::Concern

  included do
    before_action :set_world

    attr_reader :world
  end

  private
  def set_world
    @world = World.find_by(slug: params[:world_slug])
    require_permissons
  end

  # FIXME: This should once be replaced by pundit
  def require_permissons
    unless current_user == @world.user
      flash[:alert] = t(:not_allowed)
      redirect_to worlds_path
    end
  end
end
