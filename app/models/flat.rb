class Flat < ApplicationRecord
  belongs_to :user
  has_many :rooms
end
