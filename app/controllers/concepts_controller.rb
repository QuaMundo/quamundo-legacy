# frozen_string_literal: true

class ConceptsController < ApplicationController
  include WorldAssociationController
  include ProcessParams

  rescue_from ActionPolicy::Unauthorized do |_ex|
    # FIXME: Manage err msgs
    flash[:alert] = t('.not_allowed', world: @world.try(:name))
    # flash[:alert] = ex.result.reasons.full_messages
    redirect_to worlds_path
  end

  before_action :set_concept, only: %i[show edit update destroy]

  authorize :world, through: :current_world

  def index
    @concepts = current_world.concepts.order(name: :asc)
    authorize! @concepts
  end

  def new
    @concept = current_world.concepts.new(tag_attributes: {},
                                          trait_attributes: {})
    authorize! @concept
  end

  def create
    @concept = current_world.concepts.new(concept_params)
    authorize! @concept

    respond_to do |format|
      if @concept.save
        format.html do
          redirect_to(world_concept_path(current_world, @concept),
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

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @concept.update(concept_params)
        format.html do
          redirect_to(world_concept_path(current_world, @concept),
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
        redirect_to(world_concepts_path(current_world),
                    notice: t('.destroyed', concept: @concept.name))
      end
    end
  end

  private

  def set_concept
    @concept = current_world.concepts
                            .with_attached_image
                            .includes(:tag, :trait, :notes, :dossiers)
                            .find(params[:id])
    authorize! @concept
  end

  def concept_params
    # FIXME: Is it possible to put this into a concern?
    dispatch_tags_param!(params[:concept][:tag_attributes])
    dispatch_traits_param!(params[:concept][:trait_attributes])
    params.require(:concept)
          .permit(:name, :description, :image,
                  tag_attributes: [:id, { tagset: [] }],
                  trait_attributes: [:id, { attributeset: {} }])
  end
end
