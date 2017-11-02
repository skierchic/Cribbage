require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_valid(:alias).when("Susie", "Bobby")}
  it { should_not have_valid(:alias).when("")}

  it "should return the games the user has won" do
    user = User.create(alias: "Susie", email: "susie@gmail.com", password: "password")

    expect(user.games_won.count).to eq(0)

    Game.create(winner: user)
    Game.create(winner: user)
    Game.create()

    expect(Game.all.count).to eq(3)
    expect(user.games_won.count).to eq(2)
  end
end
