class Api::V1::GamesController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery unless: -> { request.format.json? }

  def index
    if current_user
      user_games_in_progress = current_user.games.where(in_progress: true)
      all_games_need_a_player = Game.where(needs_a_player: true)
      games_to_join = all_games_need_a_player.reject { |game| current_user.games.include?(game)}
      user_games_need_a_player = current_user.games.where(needs_a_player: true)

      # render json: {"games":
      #                 ActiveModel::Serializer::ArraySerializer.new(
      #                   Game.all,
      #                   serializer: GameSerializer
      #                 )
      #               }
      render :json => {
        "user_games_in_progress" => user_games_in_progress_json(user_games_in_progress),
        "games_to_join" => games_to_join_json(games_to_join),
        "user_games_need_a_player" => user_games_need_a_player_json(user_games_need_a_player),
        "wins" => current_user.win_count,
        "losses" => current_user.loss_count
      }
    else
      render status: 403, json: { error: "Sign in to see current games"}.as_json
    end
  end

  def show
    game = Game.find(params(:id))
    render :json => game.rounds.last
  end

  def create
    game = Game.start_new(current_user)
    render :json => game
  end

  def update
    game = Game.find(params(:id))
    first_round = game.add_player_and_start(current_user)
    render :json => first_round
  end

  private

  def user_games_in_progress_json(user_games_in_progress)
    user_games_in_progress.map do |game|
      {
        "id": game.id,
        "players": [game.players.first.user.alias, game.players.second.user.alias],
        "score": [game.players.first.score, game.players.second.score],
        "active_player": game.rounds.last.active_player_id,
        "last_played": game.rounds.last.updated_at.strftime('%a %d %b %Y %l:%M%P')
      }
    end
  end

  def games_to_join_json(games_to_join)
    games_to_join.map do |game|
      {
        "id": game.id,
        "player": game.players.first.user.alias,
        "game_created_date": game.created_at.strftime('%a %d %b %Y %l:%M%P')
      }
    end
  end

  def user_games_need_a_player_json(user_games_need_a_player)
    user_games_need_a_player.map do |game|
      {
        "id": game.id,
        "game_created_date": game.created_at.strftime('%a %d %b %Y %l:%M%P')
      }
    end
  end
end
