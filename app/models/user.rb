class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nick, presence: true, uniqueness: true
  validate :nick, :nick_normalized?
  has_many :worlds, dependent: :destroy
  has_many :figures, through: :worlds
end
