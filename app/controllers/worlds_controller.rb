class WorldsController < ApplicationController
  before_action :set_world, only: [:show, :edit, :update, :destroy]

  def index
    @worlds = current_user.worlds.order(name: :asc)
  end

  def show
  end

  def new
    @world = World.new
  end

  def create
    @world = current_user.worlds.new(world_params)

    respond_to do |format|
      if @world.save
        format.html do
          redirect_to(world_path(@world),
                      notice: t('.created', world: @world.name))
        end
      else
        format.html do
          # FIXME: This possibly is not tested
          flash[:alert] = t('.create_failed', world: @world.name)
          render :new
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @world.update(world_params)
        format.html do
          redirect_to(world_path(@world),
                      notice:t('.updated', world: @world.name))
        end
      else
        format.html do
          # FIXME This possibly is not testet
          flash[:alert] = t('.update_failed', world: @world.name)
          render :edit
        end
      end
    end
  end

  def destroy
    @world.destroy
    respond_to do |format|
      format.html do
        redirect_to(worlds_path,
                    notice: t('.destroyed', world: @world.name))
      end
    end
  end

  private
  def world_params
    if params[:action] == 'create'
      params.require(:world).permit(:name, :description, :image)
    else
      params.require(:world).permit(:description, :image)
    end
  end

  # FIXME: Possibly duplicated by WorldInventoryController
  def set_world
    @world = World
      .with_attached_image
      .includes(:tag, :trait, :notes, :dossiers)
      .find_by(slug: params[:slug])
    # FIXME: For perms use a lib like `pundit`!?
    require_ownership
  end

  # FIXME: This should once be replaced by pundit
  def require_ownership
    unless current_user == @world.user
      flash[:alert] = t('.not_allowed', world: @world.name)
      redirect_to worlds_path
    end
  end
end
