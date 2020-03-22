class User < ApplicationRecord
  include Nicked

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # FIXME: Get also worlds not owned by user but permitted!
  has_many :worlds, dependent: :destroy
  has_many :inventories, through: :worlds
  has_many :permissions

  # FIXME: Is this really needed?
  with_options through: :worlds do |assoc|
    assoc.has_many :figures
    assoc.has_many :items
    assoc.has_many :locations
    assoc.has_many :concepts
    assoc.has_many :facts
  end

  # FIXME: Add `admin` flag in future versions
  def admin?
    id == 0
  end
end
