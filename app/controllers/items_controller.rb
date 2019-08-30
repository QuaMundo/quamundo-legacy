class ItemsController < ApplicationController
  include WorldAssociationController

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
                      notice: t('.created'))
        end
      else
        format.html do
          # FIXME: This is untested!
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
      if @item.update(item_params)
        format.html do
          redirect_to(world_item_path(@world, @item),
                      notice: t('.updated', item: @item.name))
        end
      else
        format.html do
          # FIXME: This is untested
          flash[:alert] = t('.update_failed', item: @item.name)
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
                    notice: t('.destroyed', item: @item.name))
      end
    end
  end

  private
  def set_item
    @item = @world.items
      .with_attached_image
      .includes(:tag, :trait, :notes, :dossiers)
      .find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :image)
  end
end
