class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "game_#{params[:game_id]}"
    stream_from "user_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(move)
    # card_id = data["card_id"]
    # card = Card.find(card_id)
    # data = { "message": "#{card.rank}#{card.suit}"}
    # ActionCable.server.broadcast("game_#{params[:game_id]}", data)
    # string = "web_notifications:#{current_user.id}"
    # binding.pry
    # ActionCable.server.broadcast("user_#{current_user.id}", data)
    game = Game.find(params[:game_id])
    round = game.rounds.last
    #check that it the user's turn
    if round.active_player.user == current_user
      player = round.player(current_user)
      opponent = round.opponent(current_user)

      #update the count if the player played a card
      if move.keys.include?("new_round")
        create
      elsif move.keys.include?("card_id")
        card_id = move["card_id"]
        card = Card.find(card_id)
        new_count = round.count + card.value

        #if playing the card will keep the count at or below 31, update count and card
        if new_count <= 31
          card.update(played: true)
          round.update(count: new_count)
          score_on_card(round)
          #set the active player and end the round or reset count if necessary
          set_active_player(round)
          return_game_state(round)
        else
          ActionCable.server.broadcast("user_#{current_user.id}", { message: "Count can't go over 31.  If you can't make a move, press 'Go'" })
        end
      elsif move.keys.include?("go")
        if player.go
          player.update(go: false)
          round.update(count: 0)
        elsif !opponent.hand.empty?
          opponent.update(go: true)
          update_score(opponent, 1)
          set_active_player(round)
          message = "#{player.user.alias} gave a go ahead to #{opponent.user.alias}.  "
        else
          round.update(count: 0)
        end
        return_game_state(round)
        # ActionCable.server.broadcast("game_#{params[:game_id]}", game_state_json(round))
      else
        ActionCable.server.broadcast("user_#{current_user.id}", { message: "Error did not get a card or go" })
      end
    else
      ActionCable.server.broadcast("user_#{current_user.id}", { message: "it's not your turn" })
    end














  end

  private

  def return_game_state(round)
    opponent = round.opponent(current_user)
    ActionCable.server.broadcast("user_#{current_user.id}", game_state_json(round, current_user))
    ActionCable.server.broadcast("user_#{opponent.user.id}", game_state_json(round, opponent.user))
  end

  def return_message(user, message)
    ActionCable.server.broadcast("user_#{user.id}", { message: message })
  end

  def game_state_json(round, user, message = "")
    player = round.player(user)
    opponent = round.opponent(user)

    {
      "roundId": round.id,
      "playerAlias": player.user.alias,
      "playerHand": player.cards,
      "playerScore": player.score,
      "opponentScore": opponent.score,
      "count": round.count,
      "message": message + "#{round.active_player.user.alias}'s turn",
      "inProgress": round.in_progress,
      "isActivePlayer": round.active_player.user == user

    }
  end

  def set_active_player(round)
    player = round.player(current_user)
    opponent = round.opponent(current_user)

    #unless the player has cards and either a go or the opponent has no cards the active player switches to the opponent
    unless !player.hand.empty? && ( player.go || opponent.hand.empty?)
      round.update(active_player: opponent)

      #if neither player has cards in their hands the round is over
      if player.hand.empty? && opponent.hand.empty?
        round.update(in_progress: false)

        #if the player has a go and no cards go is removed and count is reset
      elsif player.hand.empty? && player.go
        player.update(go: false)
        round.update(count: 0)
      end
    end
  end

  def score_on_card(round)
    player = round.player(current_user)
    opponent = round.opponent(current_user)

    new_points = 0

    # 2 points for hitting 15 or 31 (only 1 point if player has a go b/c they already got one point)
    case round.count
    when 15
      new_points += 2
    when 31
      round.update(count: 0)
      if player.go
        new_points += 1
        player.update(go: false)
      else
        new_points += 2
      end
    end

    # 1 point for last card
    if player.hand.empty? && opponent.hand.empty?
      new_points += 1
    end 
  end

  def update_score(player, points_to_add)
    last_score = player.score
    new_score = last_score + points_to_add
    player.update(last_score: last_score, score: new_score)
  end

  def create
    game = Game.find(params[:game_id])
    round = game.rounds.last
    player = round.player(current_user)
    opponent = round.opponent(current_user)

    #check that round is actually over before deleting round and starting new round
    if player.hand.empty? && opponent.hand.empty?
      if round.active_player.user == current_user
        binding.pry
        Round.delete_round(round)
        player.update(is_dealer: !player.is_dealer)
        opponent.update(is_dealer: !opponent.is_dealer)
        new_round = Round.start(game)
        return_game_state(new_round)
      else
        message = "It's not your turn."
        return_message(current_user, message)
      end
    else
      error_message = ""
      error_message += player.hand.empty? ? "" : "#{player.user.alias} still has cards to play.\n"
      error_message += opponent.hand.empty? ? "" : "#{opponent.user.alias} still has cards to play.\n"
      return_message(current_user, error_message)
    end
  end
end
