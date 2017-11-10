import React from 'react'
import CardTile from '../components/CardTile'
import NewRoundButton from '../components/NewRoundButton'
import GoButton from '../components/GoButton'

class GameShowContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      playerAlias: "",
      playerHand: [{id: 1, rank: '2', suit: 'D', played: false, position: 'one'},
                      {id: 2, rank: '5', suit: 'H', played: false, position: 'two'},
                      {id: 3, rank: '8', suit: 'C', played: false, position: 'three'},
                      {id: 4, rank: 'J', suit: 'C', played: false, position: 'four'},
                      {id: 5, rank: 'A', suit: 'S', played: false, position: 'five'},
                      {id: 6, rank: 'K', suit: 'D', played: false, position: 'six'}],
      played: false,
      playerScore: 28,
      opponentScore: 15,
      message: "test message here",
      inProgress: true,
      isActivePlayer: false,
      count: 0
    };
    this.handleCardSelect = this.handleCardSelect.bind(this)
    this.handleGo = this.handleGo.bind(this)
    this.startNewRound = this.startNewRound.bind(this)
  }
  componentDidMount() {
    App.gameChannel = App.cable.subscriptions.create(
      {
        channel: "GameChannel",
        game_id: this.props.params['id']
      },
      {
        connected: () => console.log("GameChannel connected"),
        disconnected: () => console.log("GameChannel disconnected"),
        received: round => {
          this.setState(round)
        }
      }
    );

    let id = this.props.params['id']
    fetch(`/api/v1/games/${id}`, {
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
    .then(game => {
      this.setState(game.round)
    })
    .catch(error => console.error(`Error in fetch: ${error.message}`))
  }

  handleCardSelect(id) {
    let payload = { card_id: id }
    App.gameChannel.send({ card_id: id })
    this.updateRound(payload)
  }

  handleGo() {
    let payload = { go: "Go" }
    this.updateRound(payload)
  }

  updateRound(payload) {
    App.gameChannel.send(payload)
    // fetch(`/api/v1/rounds/${this.state.roundId}.json`, {
    //   method: 'PUT',
    //   credentials: 'same-origin',
    //   body: JSON.stringify(payload),
    //   headers: { 'Content-Type': 'application/json' }
    // })
    // .then(response => {
    //   if (response.ok) {
    //     return response
    //   } else {
    //     let errorMessage = `${response.status} (${response.statusText})`;
    //     let error = new Error(errorMessage);
    //     throw(error);
    //   }
    // })
    // .then(response => response.json())
    // .then(game => {
    //   this.setState(game.round)
    // })
  }


  startNewRound(){
    let payload = { new_round: "new_round"}
    this.updateRound(payload)
  //   fetch(`/api/v1/games/${game_id}/rounds.json`, {
  //    method: 'POST',
  //    credentials: 'same-origin',
  //    headers: { 'Content-Type': 'application/json' }
  //  })
  //  .then(response => {
  //    if (response.ok) {
  //      return response
  //    } else {
  //      let errorMessage = `${response.status} (${response.statusText})`;
  //      let error = new Error(errorMessage);
  //      throw(error);
  //    }
  //  })
  //  .then(response => response.json())
  //  .then(game => {
  //    this.setState(game.round)
  //  })
  }

  place_pegs(track, score) {
    let rowIndex = Math.floor(score/31)
    let columnIndex = score - 31 * rowIndex
    rowIndex = rowIndex%2
    let pegClass = `player_track${rowIndex+1} peg`
    track[rowIndex][columnIndex] = <div key={columnIndex} className={pegClass}></div>
  }
  render() {
    // let image = 'http://sweetclipart.com/multisite/sweetclipart/files/ace_of_hearts.png'
    // let image = 'http://res.freestockphotos.biz/pictures/15/15524-illustration-of-an-ace-of-diamonds-playing-card-pv.png'
    let opponentImage = this.state.played? require(`../../../../assets/images/AH.jpg`) : require(`../../../../assets/images/Yellow_back.jpg`)
    let className = this.state.played? 'played' : 'dealt'
    let playerImage
    let playerClassName
    let playerHand = this.state.playerHand.map(card => {
      playerImage = require(`../../../../assets/images/${card.rank}${card.suit}.jpg`)
      playerClassName = card.played? `played ${card.position}` : `dealt ${card.position}`
      let handleCardSelect = () => { this.handleCardSelect(card.id)}
      return(
        <CardTile image={playerImage}
                  key={card.id}
                  className={playerClassName}
                  onClick={handleCardSelect}
                />
      )
    })

    let playerTrack1 = []
    for(let hole = 0; hole < 31; hole ++) {
      playerTrack1.push(<div key={hole} className="player_track1"></div>)
    }
    let playerTrack2 = []
    for(let hole = 0; hole < 31; hole ++) {
      playerTrack2.push(<div key={hole} className="player_track2"></div>)
    }
    let playerTrack = [playerTrack1, playerTrack2]
    playerTrack = this.place_pegs(playerTrack, this.state.count)
    // track[this.state.playerScore] = <div key={this.state.playerScore} className="peg"></div>
    // playerTrack[0] = <div key='0' className="peg"></div>
    let opponentTrack1 = []
    for(let hole = 0; hole < 31; hole ++) {
      opponentTrack1.push(<div key={hole} className="opponent_track1"></div>)
    }
    let opponentTrack2 = []
    for(let hole = 0; hole < 31; hole ++) {
      opponentTrack2.push(<div key={hole} className="opponent_track2"></div>)
    }

    let showNewRoundButton = !this.state.inProgress && this.state.isActivePlayer
    let showGoButton = this.state.inProgress
    return(
      <div className='wrapper'>
        <div>Playing as {this.state.playerAlias}</div>

        <div className='opponent_cards'>
          <CardTile image={opponentImage} name='One' className={className} onClick={this.handleCardSelect}/>
          <CardTile image={opponentImage} name='Two' className={className} onClick={this.handleCardSelect}/>
          <CardTile image={opponentImage} name='Three' className={className} onClick={this.handleCardSelect}/>
          <CardTile image={opponentImage} name='Four' className={className} onClick={this.handleCardSelect}/>

        </div>
        <div className='board'>
          {opponentTrack1}
          {opponentTrack2}
          {playerTrack1}
          {playerTrack2}
        </div>
        <div className='game_readout'>
          <h1>Count: {this.state.count}</h1>
          {this.state.message}
        </div>
        <NewRoundButton show={showNewRoundButton} handleClick={this.startNewRound}/>
        <GoButton show={showGoButton} handleClick={this.handleGo}/>
        <div className='player_cards'>
          {playerHand}
        </div>

      </div>
    )
  }
}

export default GameShowContainer
