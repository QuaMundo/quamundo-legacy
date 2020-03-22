class WorldsController < ApplicationController
  include ProcessParams

  rescue_from ActionPolicy::Unauthorized do |ex|
    # FIXME: Manage err msgs
    flash[:alert] = t('.not_allowed', world: @world.try(:name))
    # flash[:alert] = ex.result.reasons.full_messages
    # FIXME: Index should never redirect, instead show empty index list!
    redirect_to ex.rule == :index? ? new_user_session_path : worlds_path
  end

  before_action :set_world, only: [:show, :edit, :update, :destroy]

  authorize :world, through: :current_world

  def index
    query = <<~SQL
      SELECT DISTINCT w.*
      FROM worlds w
      LEFT OUTER JOIN permissions p
      ON p.world_id = w.id
      WHERE (
        (w.user_id = :user_id) OR
        (p.permissions IN ('r', 'rw') AND p.user_id = :user_id) OR
        (p.permissions = 'public')
      )
      ORDER BY w.name ASC;
    SQL

    @worlds = World
      .find_by_sql([query, { user_id: current_user.try(:id) } ])
    authorize! @worlds, with: WorldPolicy
  end

  def show
  end

  def new
    @world = World.new(tag_attributes: {},
                       trait_attributes: {})
    authorize! @world
  end

  def create
    @world = current_user.worlds.new(world_params)
    authorize! @world

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
    # FIXME: Is it possible to put this into a concern?
    dispatch_tags_param!(params[:world][:tag_attributes])
    dispatch_traits_param!(params[:world][:trait_attributes])
    if params[:action] == 'create'
      params.require(:world)
        .permit(:name, :description, :image,
                tag_attributes: [:id, tagset: []],
                trait_attributes: [:id, attributeset: {}])
    else
      params.require(:world)
        .permit(:description, :image,
                permissions_attributes: [:id, :user_id, :permissions, :_destroy],
                tag_attributes: [:id, tagset: []],
                trait_attributes: [:id, attributeset: {}])
    end
  end

  # FIXME: Possibly duplicated by WorldInventoryController
  def set_world
    @world = World
      .with_attached_image
      .includes(:tag, :trait, :notes, :dossiers, permissions: [:user])
      .find_by(slug: params[:slug])
    authorize! @world
  end

  def current_world
    @world
  end
end
