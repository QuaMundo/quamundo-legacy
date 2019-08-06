module AssociatedObjectInfoHelper
  def associated_object_info(obj)
    "#{obj.model_name.human.capitalize} \"#{get_title(obj)}\""
  end

  private
  def get_title(obj)
    # FIXME: Should be obsolete since title everywhere has changed to name
    obj.try(:name) || obj.try(:title)
  end
end
