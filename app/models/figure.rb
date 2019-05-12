class Figure < ApplicationRecord
  include Imaged
  include Benamed
  include WorldAssociated
  include Noteable
  include Tagable
end
