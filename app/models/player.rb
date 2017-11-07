class Player < ApplicationRecord
  validates :score, numericality: true
  validates :last_score, numericality: true
  validates :is_dealer, inclusion: { in: [true, false] }

  belongs_to :user
  belongs_to :game
  has_many :cards
  has_many :games_won, class_name: "Game", foreign_key: "winner_id"

  def hand
    cards.where(played: false, in_crib: false)
  end

  def crib_hand
    cards.where(in_crib: true)
  end

  def played_hand
    cards.where(played: true)
  end
end
