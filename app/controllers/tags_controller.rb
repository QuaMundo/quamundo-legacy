class TagsController < ApplicationController
  include PolymorphicController
  include TagsParams

  before_action :set_tag, only: [:destroy, :edit, :update, :show]
  before_action -> { assoc_obj(@tag, :tagable) }

  def edit
    @form_url = @tag
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
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
    respond_to do |format|
      if @tag.update(tagset: [])
        format.html do
          redirect_to(@redirect_path,
                      notice: t('.destroyed'))
        end
      else
        format.html do
          flash[:alert] = t('.destroy_failed')
          render :edit
        end
      end
    end
  end

  private
  def set_tag
    @tag = Tag.find_by(id: params[:id])
  end

  def tag_params
    dispatch_tags_param!(params[:tag])
    params.require(:tag).permit({ tagset: [] })
  end
end
