class Player < ApplicationRecord
  validates :score, numericality: true
  validates :last_score, numericality: true
  validates :is_dealer, inclusion: { in: [true, false] }

  belongs_to :user
  belongs_to :game
  has_many :cards
  has_many :games_won, class_name: "Game", foreign_key: "winner_id"

  def hand
  end

  def crib_hand
  end

  def played_hand
  end
end
