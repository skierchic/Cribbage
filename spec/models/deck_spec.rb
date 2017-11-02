require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:game) {Game.create()}
  let!(:round) {Round.create(game: game)}
  let!(:round2) {Round.create(game: game)}
  let!(:deck) {Deck.create(round: round)}
  let!(:deck2) {Deck.create(round: round2)}
  let!(:card1) {Card.create(deck: deck, suit: "H", rank: "9")}
  let!(:card2) {Card.create(deck: deck, suit: "S", rank: "7")}
  let!(:card3) {Card.create(deck: deck, suit: "H", rank: "J")}
  let!(:card4) {Card.create(deck: deck, suit: "C", rank: "A")}
  let!(:card5) {Card.create(deck: deck, suit: "H", rank: "3")}
  let!(:card6) {Card.create(deck: deck2, suit: "D", rank: "K")}
  let!(:card7) {Card.create(deck: deck2, suit: "S", rank: "4")}
  let!(:card8) {Card.create(deck: deck2, suit: "C", rank: "Q")}
  let!(:card9) {Card.create(deck: deck2, suit: "C", rank: "2")}
  let!(:card10) {Card.create(deck: deck2, suit: "H", rank: "8")}

  it "should be able to find the cards associated with it" do
    expect(Card.all.count).to eq(10)
    expect(deck.cards.count).to eq(5)
  end
end
