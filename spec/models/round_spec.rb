require 'rails_helper'

RSpec.describe Round, type: :model do
  it {should have_valid(:current_stage).when("new", "discard", "play", "count")}
  it {should_not have_valid(:current_stage).when("string", 0, false)}

  it {should have_valid(:count).when(0, 2, 31)}

  let!(:jane) {User.create(alias: "Jane", email: "jane@gmail.com", password:"password")}
  let!(:jack) {User.create(alias: "Jack", email: "jack@gmail.com", password:"password")}
  let!(:jill) {User.create(alias: "Jill", email: "jill@gmail.com", password:"password")}
  let!(:game) {Game.create()}
  let!(:game2) {Game.create()}
  let!(:player_jane) {Player.create(game: game, user: jane)}
  let!(:player_jack) {Player.create(game: game, user: jack)}
  let!(:player_jill) {Player.create(game: game2, user: jill)}
  let!(:round) {Round.create(game: game, active_player: jack)}
  let!(:deck) {Deck.create(round: round)}

  it "should only update count with valid value" do
    round.update(count: "string")
    expect(round.count).to eq(0)

    round.update(count: false)
    expect(round.count).to eq(0)

    round.update(count: 8)
    expect(round.count).to eq(8)
  end

  it "should create a round with default current_stage and count if values not specified" do
    expect(round.current_stage).to eq("new")
    expect(round.count).to eq(0)
  end

  it "should find the game it's associated with" do
    expect(round.game.id).to eq(game.id)
  end

  it "should find the players in the round" do
    expect(Player.all.count).to eq(3)
    expect(round.players.count).to eq(2)
  end

  it "should find the active player in the round" do
    expect(round.active_player.alias).to eq("Jack")
  end

  it "should find the deck in the round" do
    expect(round.deck.id).to eq(deck.id)
  end
end
