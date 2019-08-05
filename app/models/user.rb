class User < ApplicationRecord
  include Nicked

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :worlds, dependent: :destroy
  has_many :inventories

  # FIXME: Can this put in a concern?
  with_options through: :worlds do |assoc|
    assoc.has_many :figures
    assoc.has_many :items
    assoc.has_many :locations
    assoc.has_many :concepts
    assoc.has_many :facts
  end
end
