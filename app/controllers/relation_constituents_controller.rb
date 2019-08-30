class RelationConstituentsController < ApplicationController
  # FIXME: Ensure user owns world!
  #include WorldAssociationController

  before_action :set_relation, only: [:new, :create, :edit, :update]
  before_action :set_relation_constituent, only: [:destroy, :update, :edit]

  def new
    @relation_constituent = @relation.relation_constituents.build
  end

  def create
    @relation_constituent = @relation
      .relation_constituents.new(relation_constituent_params)
    respond_to do |format|
      if @relation_constituent.save
        format.html do
          redirect_to(world_fact_relation_path(
            @relation.fact.world,
            @relation.fact,
            @relation),
            notice: t(
              '.created',
              constituent: '#TODO'
            ))
        end
      else
        format.html do
          # FIXME: This is untested!
          flash[:alert] = t(
            '.create_failed',
            constituent: '#TODO'
          )
          render :new
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @relation_constituent.update(relation_constituent_update_params)
        format.html do
          # FIXME: Clean this up
          fact = @relation_constituent.fact
          relation = @relation_constituent.relation
          world = fact.world
          redirect_to(
            world_fact_relation_path(world, fact, relation),
            notice: t('.updated'))
        end
      else
        format.html do
          flash[:alert] = t('.update_failed')
          render :edit
        end
      end
    end
  end

  def destroy
    @relation_constituent.destroy
    respond_to do |format|
      format.html do
        # FIXME: Clean this up
        fact = @relation_constituent.fact
        relation = @relation_constituent.relation
        world = fact.world
        redirect_to(world_fact_relation_path(world, fact, relation),
                    notice: t('.destroyed'))
      end
    end
  end

  private
  def set_relation
    # FIXME: Needs refactoring
    if params[:relation_constituent] &&
        params[:relation_constituent][:relation_id]
      @relation ||= Relation.find(params[:relation_constituent][:relation_id])
    else
      redirect_to(world_path(params[:world_slug]),
                  alert: t('.relation_param_missing'))
    end
  end

  def set_relation_constituent
    @relation_constituent ||= RelationConstituent.find(params[:id])
  end

  def relation_constituent_params
    params
      .require(:relation_constituent)
      .permit(:role, :fact_constituent_id, :relation_id)
  end

  def relation_constituent_update_params
    params
      .require(:relation_constituent)
      .permit(:role, :relation_id)
  end
end
