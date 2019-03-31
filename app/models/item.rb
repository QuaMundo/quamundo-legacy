class Item < ApplicationRecord
  include Imaged
  include Benamed
  include WorldAssociated
end
