class Round < ApplicationRecord
  validates :current_stage, inclusion: { in: ["new", "discard", "play", "count"]}
  validates :count, numericality: true

  belongs_to :game
  belongs_to :active_player, class_name: "User", optional: true
  has_many :players, through: :game
  has_one :deck
end
