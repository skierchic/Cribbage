require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_valid(:in_progress).when(true, false)}
  it { should_not have_valid(:in_progress).when("")}

  it { should have_valid(:needs_a_player).when(true, false)}
  it { should_not have_valid(:needs_a_player).when("")}

  it { should have_valid(:winner_id).when("", 2, 3)}

  let!(:user) {User.create(alias: "Jane", email: "jane@gmail.com", password:"password")}
  let!(:game) {Game.create()}
  let!(:player_jane) {Player.create(user: user, game: game)}
  let!(:game2) {Game.create}
  let!(:round) {Round.create(game: game)}
  let!(:round2) {Round.create(game: game)}
  let!(:round3) {Round.create(game: game2)}

  it "should be able to return the winner" do
    game.update(winner: player_jane)
    expect(game.winner.user.alias).to eq("Jane")
  end

  it "should be able to find any rounds associated with it" do
    expect(Round.all.count).to eq(3)
    expect(game.rounds.count).to eq(2)
  end


end
