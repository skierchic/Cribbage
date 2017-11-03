class Deck < ApplicationRecord
  belongs_to :round
  has_many :cards

  def draw(player = nil)
    card = cards.sample
    self.cards.delete(card)
    card.update(player: player)
    return card
  end

  def self.create_deck(round)
    deck = Deck.create(round: round)
    suits = ["H", "S", "D", "C"]
    ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

    suits.each do |suit|
      ranks.each do |rank|
        Card.create(deck: deck, suit: suit, rank: rank)
      end
    end
    return deck
  end
end
