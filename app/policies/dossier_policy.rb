class DossierPolicy < ApplicationPolicy
  def new?
    allowed_to?(:update?, record.dossierable)
  end

  def update?
    allowed_to?(:update?, record.dossierable)
  end

  def show?
    allowed_to?(:show?, record.dossierable)
  end
end
