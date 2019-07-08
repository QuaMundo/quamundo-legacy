class LocationsController < ApplicationController
  include WorldAssociationController

  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :set_lonlat_param, only: [:create, :update]

  def index
    @locations = @world.locations.order(name: :asc)
  end

  def new
    @location = Location.new
  end

  def create
    @location = @world.locations.new(location_params)

    respond_to do |format|
      if @location.save
        format.html do
          redirect_to(world_location_path(@world, @location),
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
  end

  def edit
  end

  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html do
          redirect_to(world_location_path(@world, @location),
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
        redirect_to(world_locations_path(@world),
                    notice: t('.destroyed', location: @location.name))
      end
    end
  end

  private
  def set_location
    @location = @world.locations.find(params[:id])
  end

  def set_lonlat_param
    # FIXME: Refactor this !?
    pos = params[:location][:lonlat]
    if pos
      lat, lon = pos.split(',')
      params[:location][:lonlat] = "POINT(#{lon} #{lat})"
    end
  end

  def location_params
    params.require(:location).permit(:name, :description, :image, :lonlat)
  end
end
