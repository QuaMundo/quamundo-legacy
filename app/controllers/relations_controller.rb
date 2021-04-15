# frozen_string_literal: true

class RelationsController < ApplicationController
  before_action :set_relation, only: %i[show edit update destroy]
  before_action :set_fact

  authorize :world, through: :current_world
  authorize :fact, through: :current_fact

  rescue_from ActionPolicy::Unauthorized do |_ex|
    # FIXME: Fix error handling (redmine #530)
    # flash[:alert] = ex.result.reason.full_messages
    flash[:alert] = t('not_allowed')
    redirect_to worlds_path
  end

  def index
    @relations = @fact.relations
    authorize! @relations
  end

  def new
    @relation = @fact.relations.new
    authorize! @relation
  end

  def create
    @relation = @fact.relations.new(relation_params)
    authorize! @relation

    respond_to do |format|
      if @relation.save
        format.html do
          redirect_to(world_fact_relation_path(@fact.world, @fact, @relation),
                      notice: t('.created', relation: @relation.name))
        end
      else
        format.html do
          flash[:alert] = t('.create_failed', relation: @relation.name)
          render :new
        end
      end
    end
  end

  def edit
    authorize! @relation
  end

  def update
    authorize! @relation
    respond_to do |format|
      if @relation.update(relation_params)
        format.html do
          redirect_to(world_fact_relation_path(
                        @relation.fact.world, @relation.fact, @relation
                      ),
                      notice: t('.updated', relation: @relation.name))
        end
      else
        format.html do
          flash[:alert] = t('.update_failed', relation: @relation.name)
          render :edit
        end
      end
    end
  end

  def show
    authorize! @relation
  end

  def destroy
    authorize! @relation
    @relation.destroy
    respond_to do |format|
      format.html do
        # FIXME: Redirect to world_fact_relations_path !!!
        redirect_to(world_fact_path(@relation.fact.world, @relation.fact),
                    notice: t('.destroyed', relation: @relation.name))
      end
    end
  end

  private

  def set_fact
    @fact = @relation.try(:fact) || Fact.find(params[:fact_id])
  end

  def current_fact
    @fact
  end

  def set_relation
    @relation = Relation.find(params[:id])
  end

  def relation_params
    strip_empty_params
    params
      .require(:relation)
      .permit(
        :name, :description, :reverse_name, :fact_id,
        relation_constituents_attributes: %i[
          id role _destroy fact_constituent_id
        ]
      )
  end

  # FIXME: Put this into a helper method
  def strip_empty_params
    params[:relation][:reverse_name] = nil if params[:relation][:reverse_name].blank?
  end

  def current_world
    @fact.world
  end
end
