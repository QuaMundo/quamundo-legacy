class NotePolicy < ApplicationPolicy
  def new?
    allowed_to?(:new?, record.noteable)
  end

  def update?
    allowed_to?(:update?, record.noteable)
  end
end
