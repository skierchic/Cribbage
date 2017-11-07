class Api::V1::RoundsController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery unless: -> { request.format.json? }

  def create
    game = Game.find(params[:game_id])
    round = game.rounds.last
    player = round.player(current_user)
    opponent = round.opponent(current_user)

    #check that round is actually over before deleting round and starting new round
    if player.hand.empty? && opponent.hand.empty?
      if round.active_player.user == current_user
        Round.delete_round(round)
        player.update(is_dealer: !player.is_dealer)
        opponent.update(is_dealer: !opponent.is_dealer)
        new_round = Round.start(game)
        render :json => {"round": game_state_json(new_round)}
      else
        render :json => {"round": { message: "it's not your turn" }}
      end
    else
      error_message = ""
      error_message += player.hand.empty? ? "" : "#{player.user.alias} still has cards to play.\n"
      error_message += opponent.hand.empty? ? "" : "#{opponent.user.alias} still has cards to play.\n"
      render :json => {"round": { message: error_message }}
    end
  end
  def update
    round = Round.find(params[:id])
    #check that it the user's turn
    if round.active_player.user == current_user
      incoming = JSON.parse(request.body.read)
      player = round.player(current_user)
      opponent = round.opponent(current_user)

      #check if a player played a card
      if incoming.keys.include?("card_id")
        card_id = incoming["card_id"]
        card = Card.find(card_id)
        new_count = round.count + card.value
        round.update(count: new_count)
        card.update(played: true)

        #set the active player or end the round
        if player.hand.empty? && opponent.hand.empty?
          round.update(active_player: opponent, in_progress: false)
        elsif opponent.hand.empty?
          round.update(active_player: player)
        else
          round.update(active_player: opponent)
        end
        render :json => {"round": game_state_json(round)}
      else
        card = 'error'
      end
    else
      render :json => {"round": { message: "it's not your turn" }}
    end
  end

  private
  #ALMOST SAME INPUT ROUND INSTEAD OF GAME also defined in round controller - change one change the other consider refactoring in the futures
    def game_state_json(round)
      player = round.player(current_user)
      opponent = round.opponent(current_user)

      {
        "roundId": round.id,
        "playerAlias": current_user.alias,
        "playerHand": player.cards,
        "playerScore": player.score,
        "opponentScore": opponent.score,
        "count": round.count,
        "message": "#{round.active_player.user.alias}'s turn",
        "inProgress": round.in_progress,
        "isActivePlayer": round.active_player.user == current_user

      }
    end
end
