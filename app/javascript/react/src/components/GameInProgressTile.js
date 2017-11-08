import React from 'react'
import {Link} from 'react-router'

const GameInProgressTile = props => {
  return(
    <div className='game_tile'>
      <Link to={`/games/${props.id}`} >
        <p>{props.player1Name} vs. {props.player2Name}</p>
        <p>{props.player1Score} - {props.player2Score}</p>
        <p>Last played: {props.lastPlayed}</p><br/>
      </Link>
    </div>
  )
}

export default GameInProgressTile
