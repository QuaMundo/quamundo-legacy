class Figure < ApplicationRecord
  belongs_to :world, touch: true
  has_one :user, through: :world
  has_one_attached :image

  def to_param
    nick
  end
end
