class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :alias, presence: true

  has_many :players
  has_many :games, through: :players
  has_many :games_won, through: :players

  def win_count
    self.games_won.count
  end
  def loss_count
    completed_games = self.games.count(:winner_id)
    loss_count = completed_games - self.win_count
  end
end
