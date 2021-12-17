class Flat < ApplicationRecord
  belongs_to :user
  has_many :rooms
  monetize :price_cents
end
