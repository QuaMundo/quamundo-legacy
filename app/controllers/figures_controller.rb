class FiguresController < ApplicationController
  include WorldAssociationController

  before_action :set_figure, only: [:show, :edit, :update, :destroy]

  def index
    @figures = @world.figures.order(name: :asc)
  end

  def show
  end

  def new
    @figure = Figure.new
  end

  def create
    @figure = @world.figures.new(figure_params)

    respond_to do |format|
      if @figure.save
        format.html do
          redirect_to(world_figure_path(@world, @figure),
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
          redirect_to(world_figure_path(@world, @figure),
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
        redirect_to(world_figures_path(@world),
                    notice: t('.destroyed', figure: @figure.name))
      end
    end
  end

  private
  def set_figure
    @figure = @world.figures
      .with_attached_image
      .includes(:tag, :trait, :notes, :dossiers)
      .find(params[:id])
  end

  def figure_params
    params.require(:figure).permit(:name, :description, :image)
  end
end
