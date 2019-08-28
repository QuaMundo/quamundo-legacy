class DossiersController < ApplicationController
  include PolymorphicController

  before_action :set_dossier, only: [:edit, :update, :destroy, :show]
  before_action :form_url, only: [:new, :create]
  before_action -> { assoc_obj(@dossier, :dossierable) }

  def show
  end

  def new
    @dossier = @assoc_obj.dossiers.new
    @form_url = [@assoc_obj.try(:world), @assoc_obj, @dossier]
  end

  def create
    @dossier = @assoc_obj.dossiers.new(dossier_params)
    respond_to do |format|
      if @dossier.save
        format.html do
          redirect_to(dossier_path(@dossier), notice: t('.created'))
        end
      else
        format.html do
          @form_url = [@assoc_obj.try(:world), @assoc_obj, @dossier]
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
        redirect_to(@redirect_path,
                    notice: t('.destroyed', dossier: @dossier.name))
      end
    end
  end

  private
  def set_dossier
    @dossier = Dossier.find_by(id: params[:id])
  end

  def dossier_params
    params.require(:dossier).permit(:name, :description, :content, files: [])
  end

  def form_url
    @form_url ||= [@assoc_obj.try(:world), @assoc_obj, @dossier]
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
end
