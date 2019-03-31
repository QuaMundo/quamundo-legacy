module Benamed
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true

    def to_param
      [id, name.parameterize].join('-')
    end
  end
end
