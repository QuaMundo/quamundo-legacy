class DossiersController < ApplicationController
  rescue_from ActionPolicy::Unauthorized do |ex|
    # FIXME: Manage err msgs
    flash[:alert] = t('.not_allowed', world: @world.try(:name))
    # flash[:alert] = ex.result.reasons.full_messages
    redirect_to worlds_path
  end

  before_action :set_dossier, only: [:edit, :update, :destroy, :show]

  authorize :world, through: :current_world

  def show
  end

  def new
    @dossier = Dossier.new(dossier_params)
    authorize! @dossier
    @form_url = form_url
  end

  def create
    @dossier = Dossier.new(dossier_params)
    authorize! @dossier
    respond_to do |format|
      if @dossier.save
        format.html do
          redirect_to(dossier_path(@dossier), notice: t('.created'))
        end
      else
        format.html do
          @form_url = form_url
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
      handle_attachments
      if @dossier.update(dossier_params)
        format.html do
          redirect_to(dossier_path(@dossier),
                      notice: t('.updated', dossier: @dossier.name))
        end
      else
        format.html do
          flash[:alert] = t('.update_failed', dossier: @dossier.name)
          render :edit
        end
      end
    end
  end

  def destroy
    @dossier.destroy
    respond_to do |format|
      format.html do
        redirect_to(
          polymorphic_path(
            [@dossier.dossierable.try(:world), @dossier.dossierable]
          ),
          notice: t('.destroyed', dossier: @dossier.name))
      end
    end
  end

  private
  def set_dossier
    @dossier = Dossier.find_by(id: params[:id])
    authorize! @dossier
  end

  def dossier_params
    params
      .require(:dossier)
      .permit(
        :name,
        :description,
        :content,
        :dossierable_id,
        :dossierable_type,
        files: [])
  end

  def form_url
    [@dossier.dossierable.try(:world), @dossier.dossierable, @dossier]
  end

  def remove_attachments
    # FIXME: Needs refactoring, maybe use `purge_later`
    if params[:remove_attachment]
      @dossier.files.find(params[:remove_attachment]).each(&:purge)
    end
  end

  def add_attachments
    if params[:dossier][:files]
      @dossier.files.attach(params[:dossier].delete(:files))
    end
  end

  def handle_attachments
    remove_attachments
    add_attachments
  end

  def current_world
    @dossier
      .dossierable
      .is_a?(World) ? @dossier.dossierable : @dossier.dossierable.world
  end
end
