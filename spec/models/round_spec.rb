require 'rails_helper'

RSpec.describe Round, type: :model do
  it {should have_valid(:current_stage).when("new", "discard", "play", "count")}
  it {should_not have_valid(:current_stage).when("string", 0, false)}

  it {should have_valid(:count).when(0, 2, 31)}

  let!(:jane) {User.create(name: "Jane", email: "jane@gmail.com", password:"password")}
  let!(:jack) {User.create(name: "Jack", email: "jack@gmail.com", password:"password")}
  let!(:jill) {User.create(name: "Jill", email: "jill@gmail.com", password:"password")}
  let!(:game) {Game.create()}
  let!(:game2) {Game.create()}
  let!(:player_jane) {Player.create(game: game, user: jane)}
  let!(:player_jack) {Player.create(game: game, user: jack, is_dealer: true)}
  let!(:player_jill) {Player.create(game: game2, user: jill)}
  let!(:round) {Round.create(game: game, active_player: player_jack)}
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
    expect(round.active_player.user.name).to eq("Jack")
  end

  it "should find the deck in the round" do
    expect(round.deck.id).to eq(deck.id)
  end

  describe "#pone" do
    it "should return the pone (non-dealer) player" do
      expect(round.pone).to eq(player_jane)
    end
  end

  describe "#dealer" do
    it "should return the player that is the dealer" do
      expect(round.dealer).to eq(player_jack)
    end
  end

  let!(:new_round) {Round.start(game)}
  describe ".start" do
    it "should return a round" do
      expect(Round.start(game)).to be_a(Round)
    end

    it "should set the pone to the active player" do
      expect(new_round.active_player).to eq(round.pone)
    end

    it "should create a new deck" do
      expect(new_round.deck).to be_a(Deck)
    end

    it "should deal 4 cards to each player" do
      expect(new_round.players.first.cards.count).to eq(4)
      expect(new_round.players.second.cards.count).to eq(4)
    end

    it "should set the current_stage to 'play'" do
      expect(new_round.current_stage).to eq("play")
    end
  end

  describe ".delete_round" do
    it "should delete the deck and all cards in the deck" do
      deck = new_round.deck
      card = deck.cards.sample
      card2 = deck.cards.sample
      Round.delete_round(new_round)

      expect(Deck.exists?(deck.id)).to be false
      expect(Card.exists?(card.id)).to be false
      expect(Card.exists?(card2.id)).to be false
    end

    it "should delete all cards in the players' hands" do
      expect(player_jane.cards.count).to_not eq(0)
      expect(player_jack.cards.count).to_not eq(0)
      Round.delete_round(new_round)
      expect(player_jane.cards.count).to eq(0)
      expect(player_jack.cards.count).to eq(0)
    end

    it "should delete the round" do
      Round.delete_round(new_round)
      expect(Round.exists?(new_round.id)).to be false
    end
  end
end
