class TraitsController < ApplicationController
  include PolymorphicController

  before_action :set_trait, only: [:destroy, :edit, :update, :show]
  before_action -> { assoc_obj(@trait, :traitable) }

  def edit
    @form_url = @trait
  end

  def update
    respond_to do |format|
      if @trait.update(trait_params)
        format.html do
          redirect_to(@redirect_path,
                      notice: t('controllers.trait.update_success'))
        end
      else
        format.html do
          flash[:alert] = t('controllers.trait.update_failed')
          render :edit
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if @trait.update(attributeset: {})
        format.html do
          redirect_to(@redirect_path,
                      notice: t('controllers.trait.delete_success'))
        end
      else
        format.html do
          flash[:alert] = t('controllers.trait.delete_failed')
          render :edit
        end
      end
    end
  end

  private
  def set_trait
    @trait = Trait.find_by(id: params[:id])
  end

  def trait_params
    merge_new
    remove_empty
    params.require(:trait).permit(:new_key, :new_value, attributeset: {})
  end

  def merge_new
    # FIXME: Needs refactoring
    if params[:trait].key?(:new_key) && params[:trait].key?(:new_value)
      key = params[:trait].delete(:new_key)
      value = params[:trait].delete(:new_value)
      unless key.nil? || key.empty? || value.nil?
        params[:trait][:attributeset] ||= {}
        params[:trait][:attributeset].merge!({ key.to_sym => value})
      end
    end
  end

  def remove_empty
    params[:trait][:attributeset].reject! { |_, v| v.to_s.empty? }
  end
end
