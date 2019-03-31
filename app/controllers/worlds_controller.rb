class WorldsController < ApplicationController
  before_action :set_world, only: [:show, :edit, :update, :destroy]
  # OPTIMIZE: For perms use a lib like `pundit`!?
  before_action :require_ownership, only: [:show, :update, :edit, :destroy]

  def index
    @worlds = current_user.worlds.order(title: :asc)
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
            notice: "World #{@world.title} successfully created.")
        end
      else
        format.html do
          flash[:alert] = "Title must be given"
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
                      notice: "World #{@world.title} successfully updated.")
        end
      else
        format.html do
          # FIXME This alert must be more generic
          flash[:alert] = "Title must not be empty"
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
                    notice: "World #{@world.title} got apocalypse")
      end
    end
  end

  private
  def world_params
    if params[:action] == 'create'
      params.require(:world).permit(:title, :description, :image)
    else
      params.require(:world).permit(:description, :image)
    end
  end

  # FIXME: Possubly duplicated by WorldInventoryController
  def set_world
    @world = World.find_by(slug: params[:slug])
  end

  # FIXME: This should once be replaced by pundit
  def require_ownership
    unless current_user == @world.user
      # FIXME: Issue with errror messages
      flash[:alert] = "This is not your world - " +
        "You are not allowed to do this action!"
      redirect_to worlds_path
    end
  end
end
