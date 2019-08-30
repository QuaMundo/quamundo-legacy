class FactConstituentsController < ApplicationController
  include WorldAssociationController

  before_action :set_fact_constituent, only: [:edit, :update, :destroy]
  before_action :set_fact

  def new
    @fact_constituent = @fact.fact_constituents.new
  end

  def create
    strip_inventory_param
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
    dispatch_roles
    params
      .require(:fact_constituent)
      .permit(:constituable_id, :constituable_type, roles: [])
  end

  def strip_inventory_param
    # FIXME: This is not clean - check if better a helper
    c_type, c_id = params[:fact_constituent].delete(:inventory).split('.')
    params[:fact_constituent][:constituable_id] = c_id
    params[:fact_constituent][:constituable_type] = c_type
  end

  def dispatch_roles
    if params[:fact_constituent][:roles].present? &&
        params[:fact_constituent][:roles].kind_of?(String)

      roles = params[:fact_constituent][:roles]
      params[:fact_constituent][:roles] = roles.split(',').map(&:strip).uniq
    else
      params[:fact_constituent][:roles] = []
    end
  end
end
