class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "game_#{params[:game_id]}"
    stream_from "user_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    card_id = data["card_id"]
    card = Card.find(card_id)
    data = { "message": "#{card.rank}#{card.suit}"}
    # ActionCable.server.broadcast("game_#{params[:game_id]}", data)
    # string = "web_notifications:#{current_user.id}"
    # binding.pry
    # ActionCable.server.broadcast("web_notifications:#{current_user.id}", data)
    ActionCable.server.broadcast("user_#{current_user.id}", data)
  end
end
