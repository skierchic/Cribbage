import React from 'react'
import CardTile from '../components/CardTile'

class GameShowContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      playerHand: [{id: 1, rank: '2', suit: 'D', played: false, position: 'one'},
                      {id: 2, rank: '5', suit: 'H', played: false, position: 'two'},
                      {id: 3, rank: '8', suit: 'C', played: false, position: 'three'},
                      {id: 4, rank: 'J', suit: 'C', played: false, position: 'four'},
                      {id: 5, rank: 'A', suit: 'S', played: false, position: 'five'},
                      {id: 6, rank: 'K', suit: 'D', played: false, position: 'six'}],
      played: false,
      playerScore: 28,
      opponentScore: 15
    };
    this.handleClick = this.handleClick.bind(this)
    this.changeCardPlayState = this.changeCardPlayState.bind(this)
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

  handleClick() {
    let newState = !this.state.played
    this.setState({played: newState})
  }
  changeCardPlayState(id) {
    let newPlayerCards = this.state.playerHand.concat()
    newPlayerCards[id - 1].played = !this.state.playerHand[id-1].played
    this.setState({ playerHand: newPlayerCards })
  }
  render() {
    debugger
    // let image = 'http://sweetclipart.com/multisite/sweetclipart/files/ace_of_hearts.png'
    // let image = 'http://res.freestockphotos.biz/pictures/15/15524-illustration-of-an-ace-of-diamonds-playing-card-pv.png'
    let opponentImage = this.state.played? require(`../../../../assets/images/AH.jpg`) : require(`../../../../assets/images/Yellow_back.jpg`)
    let className = this.state.played? 'played' : 'dealt'
    let playerImage
    let playerClassName
    let playerHand = this.state.playerHand.map(card => {
      playerImage = require(`../../../../assets/images/${card.rank}${card.suit}.jpg`)
      playerClassName = card.played? `played ${card.position}` : `dealt ${card.position}`
      let handleSingleClick = () => { this.changeCardPlayState(card.id)}
      return(
        <CardTile image={playerImage}
                  key={card.id}
                  className={playerClassName}
                  onClick={handleSingleClick}
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
    return(
      <div className='wrapper'>

        <div className='opponent_cards'>
          <CardTile image={opponentImage} name='One' className={className} onClick={this.handleClick}/>
          <CardTile image={opponentImage} name='Two' className={className} onClick={this.handleClick}/>
          <CardTile image={opponentImage} name='Three' className={className} onClick={this.handleClick}/>
          <CardTile image={opponentImage} name='Four' className={className} onClick={this.handleClick}/>
          <CardTile image={opponentImage} name='Five' className={className} onClick={this.handleClick}/>
          <CardTile image={opponentImage} name='Six' className={className} onClick={this.handleClick}/>


        </div>
        <hr/>
        <div className='board'>
          {track}
          {track}
        </div>
        <hr/>
        <div>Count: {this.state.count}</div>
        <div className='player_cards'>
          {playerHand}
        </div>

      </div>
    )
  }
}

export default GameShowContainer
