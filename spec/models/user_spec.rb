require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_valid(:alias).when("Susie", "Bobby")}
  it { should_not have_valid(:alias).when("")}

  let!(:susie) {User.create(alias: "Susie", email: "susie@gmail.com", password: "password")}
  let!(:bobby) {User.create(alias: "Bobby", email: "bobby@gamcil.com", password: "password")}
  let!(:game1) {Game.create()}
  let!(:game2) {Game.create()}
  let!(:game3) {Game.create()}
  let!(:player_susie_1) {Player.create(user: susie, game: game1)}
  let!(:player_bobby_1) {Player.create(user: bobby, game: game1)}
  let!(:player_susie_2) {Player.create(user: susie, game: game2)}
  let!(:player_bobby_2) {Player.create(user: bobby, game: game2)}
  let!(:player_susie_3) {Player.create(user: susie, game: game3)}
  let!(:player_bobby_3) {Player.create(user: bobby, game: game3)}

  it "should return the games that belong to the user" do
    expect(susie.games.count).to be(3)
    expect(bobby.games.count).to be(3)
  end

  it "should return the games the user has won" do
    expect(susie.games_won.count).to eq(0)

    game1.update(winner: player_susie_1)
    game2.update(winner: player_susie_2)
    game3.update(winner: player_bobby_3)

    expect(susie.games_won.count).to eq(2)
    expect(bobby.games_won.count).to eq(1)
  end

  describe "#win_count" do
    it "should return the number of games the player has won" do
      expect(susie.win_count).to eq(0)
      expect(bobby.win_count).to eq(0)

      game1.update(winner: player_susie_1)
      game2.update(winner: player_susie_2)
      game3.update(winner: player_bobby_3)

      expect(susie.win_count).to eq(2)
      expect(bobby.win_count).to eq(1)
    end
  end

  describe "#win_count" do
    it "should return the number of games" do
      expect(susie.win_count).to eq(0)
      expect(bobby.win_count).to eq(0)

      game1.update(winner: player_susie_1)
      game2.update(winner: player_susie_2)
      game3.update(winner: player_bobby_3)

      expect(susie.loss_count).to eq(1)
      expect(bobby.loss_count).to eq(2)
    end
  end
end
