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
                      notice: 'Note successfully created')
        end
      else
        # FIXME: Error handling
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
                      notice: "Note successfully updated")
        end
      else
        # FIXME: Error
      end
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html do
        redirect_to(@redirect_path,
                    notice: "Note successfully deleted")
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
