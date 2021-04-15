# frozen_string_literal: true

module Nicked
  extend ActiveSupport::Concern

  included do
    validate :nick, :nick_normalized?
    validates :nick, presence: true
    validates :nick, uniqueness: { case_sensitive: false }

    before_save :downcase_nick

    def to_param
      nick
    end
  end

  def nick_normalized?
    errors.add(:nick, I18n.t('nick_normalized')) unless nick =~ /^[a-zA-Z0-9][a-zA-Z0-9.\-_]*[a-zA-Z0-9]$/
  end

  def downcase_nick
    nick.downcase!
  end
end
