class NotesController < ApplicationController
  rescue_from ActionPolicy::Unauthorized do |ex|
    # FIXME: Manage err msgs
    flash[:alert] = t('.not_allowed', world: @world.try(:name))
    # flash[:alert] = ex.result.reasons.full_messages
    redirect_to worlds_path
  end

  before_action :set_note, only: [:edit, :update, :destroy]

  authorize :world, through: :current_world

  def new
    @note = Note.new(note_params)
    authorize! @note
    @form_url = [@note.noteable.try(:world), @note.noteable, @note]
  end

  def create
    @note = Note.new(note_params)
    authorize! @note
    respond_to do |format|
      if @note.save
        format.html do
          redirect_to(redirect_path, notice: t('.created'))
        end
      else
        format.html do
          # FIXME: Generating @form_url is redundant - maybe put into
          # a before_action!?
          @form_url = [@note.noteable.try(:world), @note.noteable, @note]
          flash[:alert] = t('.create_failed')
          render :new
        end
      end
    end
  end

  def edit
    @form_url = @note
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html do
          redirect_to(redirect_path, notice: t('.updated'))
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
    @note.destroy
    respond_to do |format|
      format.html do
        redirect_to(redirect_path, notice: t('.destroyed'))
      end
    end
  end

  private
  def set_note
    @note = Note.find_by(id: params[:id])
    authorize! @note
  end

  def redirect_path
    polymorphic_path([@note.noteable.try(:world), @note.noteable])
  end

  def note_params
    params
      .require(:note)
      .permit([:content, :noteable_id, :noteable_type])
  end

  def current_world
    @note
      .noteable
      .is_a?(World) ? @note.noteable : @note.noteable.world
  end
end
