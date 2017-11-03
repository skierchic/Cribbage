require 'rails_helper'

RSpec.describe Card, type: :model do
  it {should have_valid(:suit).when("H", "S", "C", "D")}
  it {should_not have_valid(:suit).when("", "other_string", 3, false)}

  it {should have_valid(:rank).when("A", "J", "3", "9")}
  it {should_not have_valid(:rank).when("", "other_string", false)}

  it {should have_valid(:played).when(true, false)}

  it {should have_valid(:in_crib).when(true, false)}


  let!(:card9) {Card.create(suit: "H", rank: "9")}
  let!(:cardA) {Card.create(suit: "H", rank: "A")}
  let!(:cardJ) {Card.create(suit: "H", rank: "J")}
  let!(:cardQ) {Card.create(suit: "H", rank: "Q")}
  let!(:cardK) {Card.create(suit: "H", rank: "K")}

  it "should create default values for played and in_crib if not specified" do
    expect(card9.played).to eq(false)
    expect(card9.in_crib).to eq(false)
  end

  describe "#value" do
    it "should return the value of the card" do
      expect(card9.value).to eq(9)
      expect(cardA.value).to eq(1)
      expect(cardJ.value).to eq(10)
      expect(cardQ.value).to eq(10)
      expect(cardK.value).to eq(10)
    end
  end

  describe "#order_value" do
    it "should return the order that will allow cards to be placed sequentially" do
      expect(card9.order_value).to eq(9)
      expect(cardA.order_value).to eq(1)
      expect(cardJ.order_value).to eq(11)
      expect(cardQ.order_value).to eq(12)
      expect(cardK.order_value).to eq(13)
    end
  end
end
