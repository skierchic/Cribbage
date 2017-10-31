class Game < ApplicationRecord
  validates :in_progress, inclusion: { in: [true, false] }
  validates :needs_a_player, inclusion: { in: [true, false] }

end
