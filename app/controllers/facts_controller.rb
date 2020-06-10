class FactsController < ApplicationController
  include WorldAssociationController
  include ProcessParams
  include FactConstituentsParams

  rescue_from ActionPolicy::Unauthorized do |ex|
    # FIXME: Manage err msgs
    if request.format.symbol == :json
      render json: 'Error', status: :unprocessable_entity
    else
      flash[:alert] = t('.not_allowed', world: @world.try(:name))
      # flash[:alert] = ex.result.reasons.full_messages
      redirect_to worlds_path
    end
  end

  before_action :set_fact, only: [:show, :edit, :update, :destroy]

  authorize :world, through: :current_world

  def index
    unless params[:inventory].present?
      @facts = current_world.facts.chronological
    else
      @facts = current_world.facts
        .joins(:fact_constituents)
        .where(
          'fact_constituents.constituable_type' => params[:inventory][:type],
          'fact_constituents.constituable_id' => params[:inventory][:id]
      ).chronological
    end
    authorize! @facts
    respond_to do |format|
      format.html { render }
      format.json { render json: @facts }
    end
  end

  def new
    @fact = current_world.facts.new(tag_attributes: {},
                                    trait_attributes: {})
    authorize! @fact
  end

  def create
    @fact = current_world.facts.new(fact_params)
    authorize! @fact

    # FIXME: Entering a non-date value does not cause an error msg

    respond_to do |format|
      if @fact.save
        format.html do
          redirect_to(world_fact_path(current_world, @fact),
                      notice: t('.created', fact: @fact.name))
        end
      else
        format.html do
          # FIXME: This is untested
          flash[:alert] = t('.create_failed', fact: @fact.name)
          render :new
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @fact }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @fact.update(fact_params)
        format.html do
          redirect_to(world_fact_path(current_world, @fact),
                      notice: t('.updated',
                                fact: @fact.name))
        end
      else
        format.html do
          # FIXME: This is untested
          flash[:alert] = t('.update_failed', fact: @fact.name)
          render :edit
        end
      end
    end
  end

  def destroy
    @fact.destroy
    respond_to do |format|
      format.html do
        redirect_to(world_facts_path(current_world),
                    notice: t('.destroyed', fact: @fact))
      end
    end
  end

  private
  def set_fact
    @fact = current_world.facts
      .with_attached_image
      .includes(:tag, :trait, :notes, :dossiers)
      .find(params[:id])
    authorize! @fact
  end

  def fact_params
    dispatch_tags_param!(params[:fact][:tag_attributes])
    dispatch_traits_param!(params[:fact][:trait_attributes])
    dispatch_fact_constituents_param!(
      params[:fact][:fact_constituents_attributes])

    params
      .require(:fact)
      .permit(:name, :description, :image, :start_date, :end_date,
              inventory:                    [:id, :type],
              tag_attributes:               [:id, tagset: [] ],
              trait_attributes:             [:id, attributeset: {}],
              fact_constituents_attributes: [:id,
                                             :constituable_id, 
                                             :constituable_type,
                                             :_destroy,
                                             roles: [] ]
             )
  end

  def fact_index_params
    params.permit(inventory: [:id, :type])
  end
end
