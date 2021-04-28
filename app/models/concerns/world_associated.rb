# frozen_string_literal: true

module WorldAssociated
  extend ActiveSupport::Concern

  included do
    belongs_to :world, touch: true
    has_one :user, through: :world
    # rubocop:disable Rails/HasManyOrHasOneDependent
    has_one :dashboard_entry, as: :inventory
    # rubocop:enable Rails/HasManyOrHasOneDependent

    attr_readonly :world_id
  end
end
