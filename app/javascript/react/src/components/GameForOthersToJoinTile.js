import React from 'react'

const GameForOthersToJoin = props => {
  return(
    <div className='game_tile'>
      Started: {props.createdAt}
    </div>
  )
}

export default GameForOthersToJoin
