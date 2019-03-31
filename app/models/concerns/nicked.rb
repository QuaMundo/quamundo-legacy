module Nicked
  extend ActiveSupport::Concern

  included do
    validate :nick, :nick_normalized?
    validates :nick, presence: true
    validates_uniqueness_of :nick, case_sensitive: false

    before_save :downcase_nick

    def to_param
      nick
    end
  end

  def nick_normalized?
    unless nick =~ %r{^[a-zA-Z0-9][a-zA-Z0-9\.\-_]*[a-zA-Z0-9]$}
      errors.add(:nick, I18n.t('nick_normalized'))
    end
  end

  def downcase_nick
    nick.downcase!
  end
end
