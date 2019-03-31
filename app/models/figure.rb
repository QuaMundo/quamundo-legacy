class Figure < ApplicationRecord
  include Imaged
  include Nicked
  include WorldAssociated
end
