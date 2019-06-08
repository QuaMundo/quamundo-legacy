module PolymorphicController
  extend ActiveSupport::Concern

  def assoc_obj(obj, assoc)
    set_assoc_obj(obj, assoc)
    set_redirect_path
  end

  private
  def set_assoc_obj(obj, assoc)
    @assoc_obj = obj.try(assoc.to_sym) ||
      get_obj ||
      World.find_by(slug: params[:world_slug])
  end

  def set_redirect_path
    @redirect_path = polymorphic_path([@assoc_obj.try(:world), @assoc_obj])
  end

  # FIXME: Is this DRY? Can it be placed  somewhere else?
  def polymorphic_models
    [World, Figure, Item, Location]
  end

  def param_id_keys
    polymorphic_models.map { |c| model_to_id c }
  end

  def get_param
    param_id_keys.find { |p| params.key?(p) }
  end

  def model_to_id(model)
    ActiveSupport::Inflector::foreign_key(model).to_sym
  end

  def get_model(id)
    polymorphic_models.find { |m| id == model_to_id(m) }
  end

  def get_obj
    id = get_param
    model = get_model(id)
    model ? model.find_by(id: params[id]) : nil
  end

end
