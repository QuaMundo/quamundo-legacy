class TagsController < ApplicationController
  include PolymorphicController

  before_action :set_tag, only: [:destroy, :edit, :update, :shoe]
  before_action -> { assoc_obj(@tag, :tagable) }

  def edit
    @form_url = @tag
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html do
          redirect_to(@redirect_path,
                      notice: 'Tags successfully updated')
        end
      else
        # FIXME: Error handling
      end
    end
  end

  def destroy
    respond_to do |format|
      if @tag.update(tagset: [])
        format.html do
          redirect_to(@redirect_path,
                      notice: "Tags successfully deleted")
        end
      else
        #FIXME: Error handling
      end
    end
  end

  private
  def set_tag
    @tag = Tag.find_by(id: params[:id])
  end

  def tag_params
    dispatch_tagset
    params.require(:tag).permit({ tagset: [] })
  end

  def dispatch_tagset
    if params[:tag][:tagset].kind_of? String
      tagset = params[:tag][:tagset]
      params[:tag][:tagset] = tagset.split(',').map(&:strip)
    end
  end
end
