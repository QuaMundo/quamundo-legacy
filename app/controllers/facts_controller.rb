class FactsController < ApplicationController
  include WorldAssociationController
  include ProcessParams
  include FactConstituentsParams

  before_action :set_fact, only: [:show, :edit, :update, :destroy]

  def index
    @facts = @world.facts.chronological
  end

  def new
    @fact = @world.facts.new(tag_attributes: {},
                             trait_attributes: {})
  end

  def create
    @fact = @world.facts.new(fact_params)

    # FIXME: Entering a non-date value does not cause an error msg

    respond_to do |format|
      if @fact.save
        format.html do
          redirect_to(world_fact_path(@world, @fact),
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
  end

  def edit
  end

  def update
    respond_to do |format|
      if @fact.update(fact_params)
        format.html do
          redirect_to(world_fact_path(@world, @fact),
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
        redirect_to(world_facts_path(@world),
                    notice: t('.destroyed', fact: @fact))
      end
    end
  end

  private
  def set_fact
    @fact = @world.facts
      .with_attached_image
      .includes(:tag, :trait, :notes, :dossiers)
      .find(params[:id])
  end

  def fact_params
    dispatch_tags_param!(params[:fact][:tag_attributes])
    dispatch_traits_param!(params[:fact][:trait_attributes])
    dispatch_fact_constituents_param!(
      params[:fact][:fact_constituents_attributes])

    params
      .require(:fact)
      .permit(:name, :description, :image, :start_date, :end_date,
              tag_attributes:               [:id,
                                             tagset: [] ],
              trait_attributes:             [:id, attributeset: {}],
              fact_constituents_attributes: [:id,
                                             :constituable_id, 
                                             :constituable_type,
                                             :_destroy,
                                             roles: [] ]
             )
  end
end
