class Card < ApplicationRecord
  validates :suit, presence: true, inclusion: { in: ["H", "S", "D", "C"]}
  validates :rank, presence: true, inclusion: { in: ["A", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]}
  validates :played, inclusion: { in: [true, false]}
  validates :in_crib, inclusion: { in: [true, false]}

  belongs_to :deck
  belongs_to :player, optional: true
end
