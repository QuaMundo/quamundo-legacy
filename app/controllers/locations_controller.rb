# frozen_string_literal: true

class LocationsController < ApplicationController
  include WorldAssociationController
  include ProcessParams
  include LocationsConcern

  rescue_from ActionPolicy::Unauthorized do |_ex|
    # FIXME: Manage err msgs
    if request.format.symbol == :json
      render json: 'Error', status: :unprocessable_entity
    else
      flash[:alert] = t('.not_allowed', world: @world.try(:name))
      # flash[:alert] = ex.result.reasons.full_messages
      redirect_to worlds_path
    end
  end

  before_action :set_location, only: %i[show edit update destroy]
  before_action :set_lonlat_param, only: %i[create update]

  authorize :world, through: :current_world

  def index
    params = location_index_params
    @locations = if params[:fact].present?
                   # FIXME: Refactor - find locations by inventories, too
                   current_world.locations
                                .joins(:fact_constituents)
                                .where('fact_constituents.fact_id' => params[:fact])
                                .order(name: :asc)
                 else
                   current_world.locations.order(name: :asc)
                 end
    authorize! @locations
    # FIXME: Where to put this?
    respond_to do |format|
      format.html { render }
      format.json do
        locations = location_json(@locations)
        render json: locations
      end
    end
  end

  def new
    @location = current_world.locations.new(tag_attributes: {},
                                            trait_attributes: {})
    authorize! @location
  end

  def create
    @location = current_world.locations.new(location_params)
    authorize! @location

    respond_to do |format|
      if @location.save
        format.html do
          redirect_to(world_location_path(current_world, @location),
                      notice: t('.created'))
        end
      else
        format.html do
          # FIXME: This is possibly untested
          flash[:alert] = t('.create_failed')
          render :new
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @location }
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html do
          redirect_to(world_location_path(current_world, @location),
                      notice: t('.updated', location: @location.name))
        end
      else
        format.html do
          # FIXME: This is possibly untested
          flash[:alert] = t('.update_failed', location: @location.name)
          render :edit
        end
      end
    end
  end

  def destroy
    @location.destroy
    respond_to do |format|
      format.html do
        redirect_to(world_locations_path(current_world),
                    notice: t('.destroyed', location: @location.name))
      end
    end
  end

  private

  def set_location
    @location = current_world.locations
                             .with_attached_image
                             .includes(:tag, :trait, :notes, :dossiers)
                             .find(params[:id])
    authorize! @location
  end

  def set_lonlat_param
    # FIXME: Refactor this !?
    pos = params[:location][:lonlat]
    return unless pos

    lat, lon = pos.split(',')
    params[:location][:lonlat] = "POINT(#{lon} #{lat})"
  end

  def location_params
    # FIXME: Is it possible to put this into a concern?
    dispatch_tags_param!(params[:location][:tag_attributes])
    dispatch_traits_param!(params[:location][:trait_attributes])
    params.require(:location)
          .permit(:name, :description, :image, :lonlat,
                  tag_attributes: [:id, { tagset: [] }],
                  trait_attributes: [:id, { attributeset: {} }])
  end

  def location_index_params
    params.permit(:fact)
  end
end
