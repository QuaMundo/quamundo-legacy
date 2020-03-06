module Factable
  extend ActiveSupport::Concern

  included do
    has_many :fact_constituents, as: :constituable, dependent: :destroy
    has_many :facts, through: :fact_constituents
    has_many :relatives, through: :fact_constituents do
      # FIXME: There is no test for chronologicality!
      def chronological
        joins(relation: :fact)
          .order('start_date ASC NULLS FIRST, end_date DESC NULLS FIRST')
      end
    end
  end
end
