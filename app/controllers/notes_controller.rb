class NotesController < ApplicationController
  include PolymorphicController

  before_action :set_note, only: [:edit, :update, :destroy, :show]
  before_action -> { assoc_obj(@note, :noteable) }

  def new
    @note = @assoc_obj.notes.new
    @form_url = [@assoc_obj.try(:world), @assoc_obj, @note]
  end

  def create
    @note = @assoc_obj.notes.new(note_params)
    respond_to do |format|
      if @note.save
        format.html do
          redirect_to(@redirect_path,
                      notice: t('.created'))
        end
      else
        format.html do
          # FIXME: Generating @form_url is redundant - maybe put into
          # a before_action!?
          @form_url = [@assoc_obj.try(:world), @assoc_obj, @note]
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
          redirect_to(@redirect_path,
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
    @note.destroy
    respond_to do |format|
      format.html do
        redirect_to(@redirect_path,
                    notice: t('.destroyed'))
      end
    end
  end

  private
  def set_note
    @note = Note.find_by(id: params[:id])
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
