class FactConstituentsController < ApplicationController
  include WorldAssociationController
  include FactConstituentsParams

  before_action :set_fact
  before_action :set_fact_constituent, only: [:edit, :update, :destroy]

  def new
    @fact_constituent = @fact.fact_constituents.new
    # FIXME: Prove that this only takes one DB query for controller and view!
    unless FactConstituentHelper
      .selectable_constituents(@fact).any?

      redirect_to(
        world_fact_path(@world, @fact),
        notice: t('.no_candidates', fact: @fact.name)
      )
    end
  end

  def create
    strip_inventory_param!(params[:fact_constituent])
    @fact_constituent = @fact.fact_constituents.new(fact_constituent_params)

    respond_to do |format|
      if @fact_constituent.save
        format.html do
          redirect_to(
            world_fact_path(@world, @fact),
            notice: t('.created', fact: @fact.name,
                      constituable: @fact_constituent.constituable.name)
          )
        end
      else
        format.html do
          # FIXME: This is untested!
          flash[:alert] = t('.create_failed', fact: @fact)
          render :new
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @fact_constituent.update(fact_constituent_params)
        format.html do
          redirect_to(
            world_fact_path(@world, @fact),
            notice: t('.updated', fact: @fact.name,
                      constituent: @fact_constituent.constituable.name)
          )
        end
      else
        format.html do
          # FIXME: This is untested!
          flash[:alert] = t('.update_failed',
                            fact: @fact.name,
                            constituent: @fact_constituent.constituable.name)
          render :edit
        end
      end
    end
  end

  def destroy
    @fact_constituent.destroy
    respond_to do |format|
      format.html do
        redirect_to(world_fact_path(@world, @fact),
                    notice: t('.destroyed'))
      end
    end
  end

  private
  def set_fact_constituent
    @fact_constituent = FactConstituent.find_by(id: params[:id])
  end

  def set_fact
    @fact = @world.facts.find(params[:fact_id])
  end

  def fact_constituent_params
    dispatch_constituent_roles!(params[:fact_constituent])
    params
      .require(:fact_constituent)
      .permit(:constituable_id, :constituable_type, roles: [])
  end
end
