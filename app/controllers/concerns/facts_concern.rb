# frozen_string_literal: true

module FactsConcern
  extend ActiveSupport::Concern

  included do
    # FIXME: Should be refactored
    def facts_by_inventory(inventory_id:, inventory_type:, world:)
      world.facts
           .joins(:fact_constituents)
           .where('fact_constituents.constituable_type' => inventory_type,
                  'fact_constituents.constituable_id' => inventory_id)
    end
  end
end
