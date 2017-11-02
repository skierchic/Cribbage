require 'rails_helper'

RSpec.describe Card, type: :model do
  it {should have_valid(:suit).when("H", "S", "C", "D")}
  it {should_not have_valid(:suit).when("", "other_string", 3, false)}

  it {should have_valid(:rank).when("A", "J", "3", "9")}
  it {should_not have_valid(:rank).when("", "other_string", false)}

  it {should have_valid(:played).when(true, false)}

  it {should have_valid(:in_crib).when(true, false)}

  let!(:game) {Game.create()}
  let!(:round) {Round.create(game: game)}
  let!(:deck) {Deck.create(round: round)}
  let!(:card) {Card.create(deck: deck, suit: "H", rank: "9")}

  it "should not create default values for played and in_crib if not specified" do
    expect(card.played).to eq(false)
    expect(card.in_crib).to eq(false)
  end
end
