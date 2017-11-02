# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

jack = User.create(alias: "Jack", email: "jack@gmail.com", password:"password")
jill = User.create(alias: "Jill", email: "jill@gmail.com", password:"password")
game = Game.create()
player_jack = Player.create(game: game, user: jack)
player_jill = Player.create(game: game, user: jill)
round = Round.create(game: game, active_player: jack)
deck = Deck.create(round: round)

suits = ["H", "S", "D", "C"]
ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

suits.each do |suit|
  ranks.each do |rank|
    Card.create(deck: deck, suit: suit, rank: rank)
  end
end
