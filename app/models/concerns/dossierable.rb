module Dossierable
  extend ActiveSupport::Concern

  included do
    has_many :dossiers, as: :dossierable, dependent: :destroy

    after_create :add_std_dossier

    private
    def add_std_dossier
      self.dossiers.create(name: self.name)
    end
  end
end
