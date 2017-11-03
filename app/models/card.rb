class Card < ApplicationRecord
  validates :suit, presence: true, inclusion: { in: ["H", "S", "D", "C"]}
  validates :rank, presence: true, inclusion: { in: ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]}
  validates :played, inclusion: { in: [true, false]}
  validates :in_crib, inclusion: { in: [true, false]}

  belongs_to :deck, optional: true
  belongs_to :player, optional: true

  def value
    if rank == "A"
      1
    elsif rank.to_i == 0
      10
    else
      rank.to_i
    end
  end

  def order_value
    if value != 10
      value
    else
      value + ["10", "J", "Q", "K"].index(rank)
    end
  end

end
