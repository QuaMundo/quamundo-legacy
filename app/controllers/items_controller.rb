# frozen_string_literal: true

class ItemsController < ApplicationController
  include WorldAssociationController
  include ProcessParams

  rescue_from ActionPolicy::Unauthorized do |_ex|
    # FIXME: Manage err msgs
    flash[:alert] = t('.not_allowed', world: @world.try(:name))
    # flash[:alert] = ex.result.reasons.full_messages
    redirect_to worlds_path
  end

  before_action :set_item, only: %i[show edit update destroy]

  authorize :world, through: :current_world

  def index
    @items = current_world.items.order(name: :asc)
    authorize! @items
  end

  def show; end

  def new
    @item = current_world.items.new(tag_attributes: {},
                                    trait_attributes: {})
    authorize! @item
  end

  def create
    @item = current_world.items.new(item_params)
    authorize! @item

    respond_to do |format|
      if @item.save
        format.html do
          redirect_to(world_item_path(current_world, @item),
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

  def edit; end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html do
          redirect_to(world_item_path(current_world, @item),
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
        redirect_to(world_items_path(current_world),
                    notice: t('.destroyed', item: @item.name))
      end
    end
  end

  private

  def set_item
    @item = current_world.items
                         .with_attached_image
                         .includes(:tag, :trait, :notes, :dossiers)
                         .find(params[:id])
    authorize! @item
  end

  def item_params
    # FIXME: Is it possible to put this into a concern?
    dispatch_tags_param!(params[:item][:tag_attributes])
    dispatch_traits_param!(params[:item][:trait_attributes])
    params.require(:item)
          .permit(:name, :description, :image,
                  tag_attributes: [:id, { tagset: [] }],
                  trait_attributes: [:id, { attributeset: {} }])
  end
end
