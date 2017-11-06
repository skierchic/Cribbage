import React from 'react'
import {Link} from 'react-router'

const GameToJoinTile = props => {
  return(
    <div className='game_tile' onClick={props.handleClick}>
      <Link to={`/games/${props.id}`} >
        <p>Player: {props.player}</p>
        <p>Started: {props.createdAt}</p>
      </Link>
    </div>
  )
}

export default GameToJoinTile
