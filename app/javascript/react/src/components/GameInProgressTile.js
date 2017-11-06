import React from 'react'

const GameInProgressTile = props => {
  return(
    <div className='game_tile'>
      <p>{props.player1Name} vs. {props.player2Name}</p>
      <p>{props.player1Score} - {props.player2Score}</p>
      <p>Last played: {props.lastPlayed}</p><br/>
    </div>
  )
}

export default GameInProgressTile
