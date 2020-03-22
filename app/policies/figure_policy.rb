class FigurePolicy < ApplicationPolicy
  def new?
    allowed_to?(:update?, world)
  end

  def edit?
    allowed_to?(:update?, world)
  end

  def update?
    allowed_to?(:update?, world)
  end

  def show?
    allowed_to?(:show?, world)
  end

  def index?
    allowed_to?(:show?, world)
  end
end
