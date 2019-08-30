class ConceptsController < ApplicationController
  include WorldAssociationController

  before_action :set_concept, only: [:show, :edit, :update, :destroy]

  def index
    @concepts = @world.concepts.order(name: :asc)
  end

  def new
    @concept = Concept.new
  end

  def create
    @concept = @world.concepts.new(concept_params)

    respond_to do |format|
      if @concept.save
        format.html do
          redirect_to(world_concept_path(@world, @concept),
                                notice: t('.created'))
        end
      else
        format.html do
          # FIXME: This is untested
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
      if @concept.update(concept_params)
        format.html do
          redirect_to(world_concept_path(@world, @concept),
                      notice: t('.updated', concept: @concept.name))
        end
      else
        format.html do
          # FIXME: This is untested
          flash[:alert] = t('.update_failed', concept: @concept.name)
          render :edit
        end
      end
    end
  end

  def destroy
    @concept.destroy
    respond_to do |format|
      format.html do
        redirect_to(world_concepts_path(@world),
                    notice: t('.destroyed', concept: @concept.name))
      end
    end
  end

  private
  def set_concept
    @concept = @world.concepts
      .with_attached_image
      .includes(:tag, :trait, :notes, :dossiers)
      .find(params[:id])
  end

  def concept_params
    params.require(:concept).permit(:name, :description, :image)
  end
end
