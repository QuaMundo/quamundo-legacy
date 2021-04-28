# frozen_string_literal: true

class User < ApplicationRecord
  include Nicked

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # FIXME: Get also worlds not owned by user but permitted!
  has_many :worlds, dependent: :destroy
  has_many :inventories, through: :worlds
  has_many :permissions, dependent: :destroy

  # FIXME: Is this really needed?
  with_options through: :worlds do
    has_many :figures
    has_many :items
    has_many :locations
    has_many :concepts
    has_many :facts
  end

  # FIXME: Add `admin` flag in future versions
  def admin?
    id.zero?
  end
end
