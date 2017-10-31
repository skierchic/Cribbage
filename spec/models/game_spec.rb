require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_valid(:in_progress).when(true, false)}
  it { should_not have_valid(:in_progress).when("")}

  it { should have_valid(:needs_a_player).when(true, false)}
  it { should_not have_valid(:needs_a_player).when("")}

  it { should have_valid(:winner_id).when("", 2, 3)}
end
