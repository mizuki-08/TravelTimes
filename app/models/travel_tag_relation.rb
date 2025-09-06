class TravelTagRelation < ApplicationRecord
  belongs_to :travel
  belongs_to :tag
end
