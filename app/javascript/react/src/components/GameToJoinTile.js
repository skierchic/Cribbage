import React from 'react'

const GameToJoinTile = props => {
  return(
    <div className='game_tile'>
      <p>Player: {props.player}</p>
      <p>Started: {props.createdAt}</p>
    </div>
  )
}

export default GameToJoinTile
