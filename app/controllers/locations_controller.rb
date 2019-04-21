class LocationsController < WorldInventoryController
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
                      # FIXME: I18n
                      notice: "Location #{@location.name} successfully created")
        end
      else
        format.html do
          # FIXME: I18n
          flash[:alert] = "Name must be given"
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
                      # FIXME: I18n
                      notice: "Location: #{@location.name} sucessfully updated.")
        end
      else
        format.html do
          # FIXME: I18n
          flash[:alert] = "Location updated"
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
          notice: "Location: #{@location.name} successfully deleted")
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
