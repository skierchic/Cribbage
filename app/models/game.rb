class Game < ApplicationRecord
  validates :in_progress, inclusion: { in: [true, false] }
  validates :needs_a_player, inclusion: { in: [true, false] }

  belongs_to :winner, class_name: "Player", optional: true
  has_many :players
  has_many :rounds

end
