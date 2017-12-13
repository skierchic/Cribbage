require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:jane) {User.create(name: "Jane", email: "jane@gmail.com", password:"password")}
  let!(:game) {Game.create()}
  let!(:player_jane) {Player.create(game: game, user: jane)}
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
    expect(Card.all.count).to eq(62)
    expect(deck.cards.count).to eq(5)
  end

  describe "#draw" do
    it "should return a card" do
      expect(deck.draw).to be_a(Card)
    end

    it "should remove the returned card from the deck" do
      count = deck.cards.count
      card = deck.draw
      expect(deck.cards.count).to eq(count - 1)
      expect(deck.cards.include?(card)).to be false
    end

    it "should assign the card to a player if a player is passed in" do
      card = deck.draw(player_jane)
      expect(card.player).to eq(player_jane)
    end
  end

  let!(:deck3) {Deck.create_deck(round)}
  describe ".create_deck" do
    it "should return a new deck with 52 cards" do
      expect(deck3).to be_a(Deck)
      expect(deck3.cards.count).to eq(52)
    end

    it "should not contain duplicate cards" do
      expect(deck3.cards).to eq(deck3.cards.uniq)
    end
  end
end
