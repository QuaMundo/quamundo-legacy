module ApplicationHelper
  # Element ID helper - creates ids for html elements
  def element_id(obj, prefix = nil)
    [prefix, obj.class.to_s.downcase, obj.id].reject(&:nil?).join('-')
  end
end
