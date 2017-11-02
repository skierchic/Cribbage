class Deck < ApplicationRecord
  belongs_to :round
  has_many :cards
end
