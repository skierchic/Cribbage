require 'rails_helper'

RSpec.describe Player, type: :model do
  it { should have_valid(:score).when(0, 10) }

  it { should have_valid(:last_score).when(0, 10) }

  it { should have_valid(:is_dealer).when(true, false) }

  let!(:user) {User.create(name: "Jane", email: "jane@gmail.com", password:"password")}
  let!(:game) {Game.create()}
  let!(:player) {Player.create(game: game, user: user)}
  let!(:player_with_values) {Player.create(game: game, user: user, score: 5, last_score: 2, is_dealer: true)}
  let!(:round) {Round.create(game: game)}
  let!(:deck) {Deck.create(round: round)}
  let!(:card1) {Card.create(deck: deck, rank: "J", suit: "H", player: player)}
  let!(:card2) {Card.create(deck: deck, rank: "J", suit: "H", player: player)}
  let!(:card3) {Card.create(deck: deck, rank: "J", suit: "H")}

  it "should create with defaults if scores and dealer are not explicitly set" do
    expect(player_with_values.score).to eq(5)
    expect(player_with_values.last_score).to eq(2)
    expect(player_with_values.is_dealer).to eq(true)
  end

  it "should create with given values if scores and dealer are explicitly set" do
    expect(player.score).to eq(0)
    expect(player.last_score).to eq(0)
    expect(player.is_dealer).to eq(false)
  end

  it "should find the game and user it's associated with" do
    expect(player.user.name).to eq("Jane")
    expect(player.game.id).to eq(game.id)
  end

  it "should only update score for valid values" do
    player.update(score: "string")
    expect(player.score).to eq(0)

    player.update(score: 5)
    expect(player.score).to eq(5)
  end

  it "should only update last_score for valid values" do
    player.update(last_score: "string")
    expect(player.last_score).to eq(0)

    player.update(last_score: 5)
    expect(player.last_score).to eq(5)
  end

  it "should be able to find a player's cards" do
    expect(Card.all.count).to eq(3)
    expect(player.cards.count).to eq(2)
  end
end
