class RelationsController < ApplicationController
  before_action :set_fact
  before_action :set_relation, only: [:show, :edit, :update, :destroy]

  def index
    @relations = @fact.relations
  end

  def new
    @relation = @fact.relations.new
  end

  def create
    @relation = @fact.relations.new(relation_params)

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
  end

  def update
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
          flash[:alert] = t('.update-failed', relation: @relation.name)
          render :edit
        end
      end
    end
  end

  def show
  end

  def destroy
    @relation.destroy
    respond_to do |format|
      format.html do
        redirect_to(world_fact_path(@relation.fact.world, @relation.fact),
                    notice: t('.destroyed', relation: @relation.name))
      end
    end
  end

  private
  # FIXME: Refactor: DRY up (-> WorldAssociationController)
  def require_permisson
    unless current_user == @fact.world.user
      flash[:alert] = t(:not_allowed)
      redirect_to worlds_path
    end
  end

  def set_fact
    @fact = @relation.try(:fact) || Fact.find(params[:fact_id])
    # FIXME: Refactor: DRY up (-> WorldAssociationController)
    require_permisson
  end

  def set_relation
    @relation = Relation.find(params[:id])
  end

  def relation_params
    strip_empty_params
    params
      .require(:relation)
      .permit(:name, :description, :reverse_name)
  end

  # FIXME: Put this into a helper method
  def strip_empty_params
    if params[:relation][:reverse_name].blank?
      params[:relation][:reverse_name] = nil
    end
  end
end
