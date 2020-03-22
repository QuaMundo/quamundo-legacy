class FiguresController < ApplicationController
  include WorldAssociationController
  include ProcessParams

  rescue_from ActionPolicy::Unauthorized do |ex|
    # FIXME: Manage err msgs
    flash[:alert] = t('.not_allowed', world: @world.try(:name))
    # flash[:alert] = ex.result.reasons.full_messages
    redirect_to worlds_path
  end

  before_action :set_figure, only: [:show, :edit, :update, :destroy]

  authorize :world, through: :current_world

  def index
    @figures = current_world.figures.order(name: :asc)
    authorize! @figures
  end

  def show
  end

  def new
    @figure = current_world.figures.new(tag_attributes: {},
                                        trait_attributes: {})
    authorize! @figure
  end

  def create
    @figure = current_world.figures.new(figure_params)
    authorize! @figure

    respond_to do |format|
      if @figure.save
        format.html do
          redirect_to(world_figure_path(current_world, @figure),
                      notice: t('.created'))
        end
      else
        format.html do
          # FIXME: This is possibly untested!
          flash[:alert] = t('.create_failed')
          render :new
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @figure.update(figure_params)
        format.html do
          redirect_to(world_figure_path(current_world, @figure),
                      notice: t('.updated', figure: @figure.name))
        end
      else
        format.html do
          flash[:alert] = t('.update_failed', figure: @figure.name)
          render :edit
        end
      end
    end
  end

  def destroy
    @figure.destroy
    respond_to do |format|
      format.html do
        redirect_to(world_figures_path(current_world),
                    notice: t('.destroyed', figure: @figure.name))
      end
    end
  end

  private
  def set_figure
    @figure = current_world.figures
      .with_attached_image
      .includes(:tag, :trait, :notes, :dossiers)
      .find(params[:id])
    authorize! @figure
  end

  def figure_params
    # FIXME: Is it possible to put this into a concern?
    dispatch_tags_param!(params[:figure][:tag_attributes])
    dispatch_traits_param!(params[:figure][:trait_attributes])
    params.require(:figure)
      .permit(:name, :description, :image,
              figure_ancestors_attributes: [:id,
                                            :ancestor_id,
                                            :name,
                                            :_destroy],
              tag_attributes: [:id, tagset: []],
              trait_attributes: [:id, attributeset: {}])
  end
end
