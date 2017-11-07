import React from 'react';
import GameInProgressTile from '../components/GameInProgressTile'
import GameToJoinTile from '../components/GameToJoinTile'
import GameForOthersToJoinTile from '../components/GameForOthersToJoinTile'
import NewGameButton from '../components/NewGameButton'


class GameIndexContainer extends React.Component{
  constructor(props) {
    super(props);
    this.state = {
      gamesInProgress: [],
      gamesToJoin: [],
      gamesForOthersToJoin: [],
      wins: null,
      losses: null
    }
    this.addNewGame = this.addNewGame.bind(this)
    this.addPlayerToGame = this.addPlayerToGame.bind(this)
  }

  componentDidMount() {
    fetch('/api/v1/games', {
     credentials: 'same-origin',
     method: 'GET',
     headers: { 'Content-Type': 'application/json' }
   })
    .then(response => {
      if (response.ok) {
        return response;
      } else {
        let errorMessage = `${response.status} (${response.statusText})`,
            error = new Error(errorMessage);
          throw(error);
      }
    })
    .then(response => response.json())
    .then(games => {
      this.setState({
        gamesInProgress: games.user_games_in_progress,
        gamesToJoin: games.games_to_join,
        gamesForOthersToJoin: games.user_games_need_a_player,
        wins: games.wins,
        losses: games.losses
      })
    })
    .catch(error => console.error(`Error in fetch: ${error.message}`))
  }

  addNewGame(){
    fetch('/api/v1/games.json', {
     method: 'POST',
     credentials: 'same-origin',
     headers: { 'Content-Type': 'application/json' }
   })
   .then(response => {
     if (response.ok) {
       return response
     } else {
       let errorMessage = `${response.status} (${response.statusText})`;
       let error = new Error(errorMessage);
       throw(error);
     }
   })
   .then(response => response.json())
   .then(response => {
     this.setState( {gamesForOthersToJoin: [response,...this.state.gamesForOthersToJoin]} )
   })
  }

  addPlayerToGame(id){
    fetch(`/api/v1/games/${id}.json`, {
     method: 'PUT',
     credentials: 'same-origin',
     headers: { 'Content-Type': 'application/json' }
   })
   .then(response => {
     if (response.ok) {
       return response
     } else {
       let errorMessage = `${response.status} (${response.statusText})`;
       let error = new Error(errorMessage);
       throw(error);
     }
   })
   .then(response => response.json())
   .then(response => {
     debugger

   })
  }

  render() {
    let gamesInProgress = this.state.gamesInProgress.map( game => {
      return(
        <GameInProgressTile
          key={game.id}
          player1Name={game.players[0]}
          player2Name={game.players[1]}
          player1Score={game.score[0]}
          player2Score={game.score[1]}
          lastPlayed={game.last_played}
        />
      )
    })
    // let addPlayerToGame = (event) => this.addPlayerToGame(event)
    let gamesToJoin = this.state.gamesToJoin.map( game => {
      let addPlayerToGame = () => { this.addPlayerToGame(game.id) }
      return(
        <GameToJoinTile
          key={game.id}
          id={game.id}
          player={game.player}
          createdAt={game.game_created_date}
          handleClick={addPlayerToGame}
        />
      )
    })
    let gamesForOthersToJoin = this.state.gamesForOthersToJoin.map( game => {
      return(
        <GameForOthersToJoinTile
          key={game.id}
          createdAt={game.game_created_date}
        />
      )
    })

    return(
      <div>
        All Time Record: {this.state.wins}:{this.state.losses} <br/>

        <NewGameButton handleClick={this.addNewGame}/> <br />

        Continue a Game: <br/>
        {gamesInProgress} <br/>

        Join a Game: <br/>
        {gamesToJoin} <br/>

        Your Games Waiting on An Opponent: <br/>
        {gamesForOthersToJoin} <br/>
      </div>
    )
  }
}

export default GameIndexContainer;
