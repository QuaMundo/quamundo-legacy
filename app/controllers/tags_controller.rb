class TagsController < ApplicationController
  include PolymorphicController

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
                      notice: t('controllers.tag.update_success'))
        end
      else
        format.html do
          flash[:alert] = t('controllers.tag.update_failed')
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
                      notice: t('controllers.tag.delete_success'))
        end
      else
        format.html do
          flash[:alert] = t('controllers.tag.delete_failed')
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
