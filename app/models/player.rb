class Player < ApplicationRecord
  validates :score, numericality: true
  validates :last_score, numericality: true
  validates :is_dealer, inclusion: { in: [true, false] }

  belongs_to :user
  belongs_to :game
  has_many :cards
end
