class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nick, presence: true, uniqueness: true
  validate :nick, :nick_normalized?
  has_many :worlds, dependent: :destroy
  # FIXME: nick must not be nil - remove condition
  # Attention: causes other test to catch wrong exception
  before_save { nick.downcase! unless nick.nil? }

  protected
  def nick_normalized?
    unless nick =~ %r{^[a-zA-Z0-9][a-zA-Z0-9\.\-_]*[a-zA-Z0-9]$}
      errors.add(:nick, 'May only contain letters, numbers and ._- ' +
                 'and must start and end with a letter or number')
    end
  end
end
