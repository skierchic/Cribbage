class Api::V1::GamesController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery unless: -> { request.format.json? }

  def index
    user_games_in_progress = current_user.games.where(in_progress: true)
    all_games_need_a_player = Game.where(needs_a_player: true)
    games_to_join = all_games_need_a_player.reject { |game| current_user.games.include?(game)}
    user_games_need_a_player = current_user.games.where(needs_a_player: true)
    render :json => {
      "user_games_in_progress" => user_games_in_progress),
      "games_to_join" => games_to_join,
      "user_games_need_a_player" => user_games_need_a_player}
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
end
