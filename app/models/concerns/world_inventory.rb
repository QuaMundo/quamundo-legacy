# frozen_string_literal: true

module WorldInventory
  extend ActiveSupport::Concern

  included do
    include Imaged
    include Benamed
    include WorldAssociated
    include Noteable
    include Tagable
    include Traitable
    include Dossierable
  end
end
