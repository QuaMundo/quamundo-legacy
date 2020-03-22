class RelationPolicy < ApplicationPolicy
  pre_check :context_fact, only: [:index?]

  def new?
    allowed_to?(:update?, record.fact)
  end

  def edit?
    allowed_to?(:update?, record.fact)
  end

  def update?
    allowed_to?(:update?, record.fact)
  end

  def show?
    allowed_to?(:show?, record.fact)
  end

  def index?
    allowed_to?(:show?, fact)
  end

  private
  def context_fact
    deny! unless fact.present?
  end
end
