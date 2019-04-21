class Location < ApplicationRecord
  include Imaged
  include Benamed
  include WorldAssociated
end
