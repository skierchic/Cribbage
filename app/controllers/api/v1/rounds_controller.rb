class Api::V1::RoundsController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery unless: -> { request.format.json? }

  # def create
  #   game = Game.find(params[:game_id])
  #   round = game.rounds.last
  #   player = round.player(current_user)
  #   opponent = round.opponent(current_user)
  #
  #   #check that round is actually over before deleting round and starting new round
  #   if player.hand.empty? && opponent.hand.empty?
  #     if round.active_player.user == current_user
  #       Round.delete_round(round)
  #       player.update(is_dealer: !player.is_dealer)
  #       opponent.update(is_dealer: !opponent.is_dealer)
  #       new_round = Round.start(game)
  #       render :json => {"round": game_state_json(new_round)}
  #     else
  #       render :json => {"round": { message: "it's not your turn" }}
  #     end
  #   else
  #     error_message = ""
  #     error_message += player.hand.empty? ? "" : "#{player.user.name} still has cards to play.\n"
  #     error_message += opponent.hand.empty? ? "" : "#{opponent.user.name} still has cards to play.\n"
  #     render :json => {"round": { message: error_message }}
  #   end
  # end
  # def update
  #   round = Round.find(params[:id])
  #   #check that it the user's turn
  #   if round.active_player.user == current_user
  #     move = JSON.parse(request.body.read)
  #     player = round.player(current_user)
  #     opponent = round.opponent(current_user)
  #
  #     #update the count if the player played a card
  #     if move.keys.include?("card_id")
  #       card_id = move["card_id"]
  #       card = Card.find(card_id)
  #       new_count = round.count + card.value
  #
  #       #if playing the card will keep the count at or below 31, update count and card
  #       if new_count <= 31
  #         card.update(played: true)
  #         round.update(count: new_count)
  #         update_score_on_card(round)
  #         #set the active player and end the round or reset count if necessary
  #         set_active_player(round)
  #         render :json => {"round": game_state_json(round)}
  #       else
  #         render :json => {"round": { message: "Count can't go over 31.  If you can't make a move, press 'Go'" }}
  #       end
  #     elsif move.keys.include?("go")
  #       if player.go
  #         player.update(go: false)
  #         round.update(count: 0)
  #       else
  #         opponent.update(go: true)
  #         set_active_player(round)
  #         message = "#{player.user.name} gave a go ahead to #{opponent.user.name}.  "
  #       end
  #       render :json => {"round": game_state_json(round)}
  #     else
  #       render :json => {"round": { message: "Error did not get a card or go" }}
  #     end
  #   else
  #     render :json => {"round": { message: "it's not your turn" }}
  #   end
  # end

  private
  #ALMOST SAME INPUT ROUND INSTEAD OF GAME also defined in round controller - change one change the other consider refactoring in the futures THIS IS ALSO COPIED TO CHANNEL can I move it to the model?
  def game_state_json(round, message = "")
    player = round.player(current_user)
    opponent = round.opponent(current_user)

    {
      "roundId": round.id,
      "playerAlias": current_user.name,
      "playerHand": player.cards,
      "playerScore": player.score,
      "opponentScore": opponent.score,
      "count": round.count,
      "message": message + "#{round.active_player.user.name}'s turn",
      "inProgress": round.in_progress,
      "isActivePlayer": round.active_player.user == current_user

    }
  end

  # def set_active_player(round)
  #   player = round.player(current_user)
  #   opponent = round.opponent(current_user)
  #
  #   #unless the player has cards and either a go or the opponent has no cards the active player switches to the opponent
  #   unless !player.hand.empty? && ( player.go || opponent.hand.empty?)
  #     round.update(active_player: opponent)
  #
  #     #if neither player has cards in their hands the round is over
  #     if player.hand.empty? && opponent.hand.empty?
  #       round.update(in_progress: false)
  #
  #       #if the player has a go and no cards go is removed and count is reset
  #     elsif player.hand.empty? && player.go
  #       player.update(go: false)
  #       round.update(count: 0)
  #     end
  #   end
  # end

  # def update_score_on_card(round)
  #   player = round.player(current_user)
  #   opponent = round.opponent(current_user)
  #
  #   new_points = 0
  #   case round.count
  #   when 15
  #     new_points = 2
  #   when 31
  #     new_points = 2
  #     round.update(count: 0)
  #   end
  #
  #   if new_points > 0
  #     last_score = player.score
  #     new_score = last_score + new_points
  #     player.update(last_score: last_score, score: new_score)
  #   end
  #
  # end
end
