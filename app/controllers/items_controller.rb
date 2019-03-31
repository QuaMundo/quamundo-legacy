class ItemsController < WorldInventoryController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = @world.items.order(name: :asc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = @world.items.new(item_params)

    respond_to do |format|
      if @item.save
        format.html do
          redirect_to(world_item_path(@world, @item),
                      # FIXME: I18n
                      notice: "Item #{@item.name} successfully created")
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
      if @item.update(item_params)
        format.html do
          redirect_to(world_item_path(@world, @item),
                      # FIXME: I18n
                      notice: "Item #{@item.name} successfully updated.")
        end
      else
        format.html do
          # FIXME: I18n
          flash[:alert] = "Item update failed"
          render :edit
        end
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html do
        redirect_to(world_items_path(@world),
                    notice: "Item #{@item.name} successfully deleted")
      end
    end
  end

  private
  def set_item
    @item = @world.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :image)
  end
end
