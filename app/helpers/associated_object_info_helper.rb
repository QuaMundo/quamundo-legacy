# frozen_string_literal: true

module AssociatedObjectInfoHelper
  def associated_object_info(obj)
    "#{obj.model_name.human.capitalize} \"#{get_title(obj)}\""
  end

  private

  def get_title(obj)
    obj.try(:name) || ''
  end
end
