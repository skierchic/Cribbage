import React from 'react'
import CardTile from '../components/CardTile'
import NewRoundButton from '../components/NewRoundButton'

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
      isActivePlayer: false
    };
    this.handleCardSelect = this.handleCardSelect.bind(this)
    this.startNewRound = this.startNewRound.bind(this)
  }
  componentDidMount() {
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
    this.updateRound(payload)
  }
  updateRound(payload) {
    fetch(`/api/v1/rounds/${this.state.roundId}.json`, {
      method: 'PUT',
      credentials: 'same-origin',
      body: JSON.stringify(payload),
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
    .then(game => {
      this.setState(game.round)
    })
  }

  startNewRound(){
    let game_id = this.props.params.id
    fetch(`/api/v1/games/${game_id}/rounds.json`, {
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
   .then(game => {
     this.setState(game.round)
   })
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

    let track = []
    for(let hole = 0; hole < 122; hole ++) {
      track.push(<div key={hole}></div>)
    }
    track[this.state.playerScore] = <div key={this.state.playerScore} className="peg"></div>
    track[0] = <div key='0' className="peg"></div>
    track[1] = <div key='1' className="space"></div>

    let showNewRoundButton = !this.state.inProgress && this.state.isActivePlayer
    return(
      <div className='wrapper'>
        <div>Playing as {this.state.playerAlias}</div>

        <div className='opponent_cards'>
          <CardTile image={opponentImage} name='One' className={className} onClick={this.handleCardSelect}/>
          <CardTile image={opponentImage} name='Two' className={className} onClick={this.handleCardSelect}/>
          <CardTile image={opponentImage} name='Three' className={className} onClick={this.handleCardSelect}/>
          <CardTile image={opponentImage} name='Four' className={className} onClick={this.handleCardSelect}/>
          <CardTile image={opponentImage} name='Five' className={className} onClick={this.handleCardSelect}/>
          <CardTile image={opponentImage} name='Six' className={className} onClick={this.handleCardSelect}/>


        </div>
        <hr/>
        <div className='board'>
          {track}
          {track}
        </div>
        <hr/>
        <div className='message'>
          Count: {this.state.count} <br/>
          {this.state.message}
        </div>
        <NewRoundButton show={showNewRoundButton} handleClick={this.startNewRound}/>
        <div className='player_cards'>
          {playerHand}
        </div>

      </div>
    )
  }
}

export default GameShowContainer
