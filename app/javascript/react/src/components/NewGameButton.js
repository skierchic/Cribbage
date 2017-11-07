import React from 'react'

const NewGameButton = props => {
  return(
    <div className='game_tile new_game' onClick={props.handleClick}>
      Start a New Game
    </div>
  )
}

export default NewGameButton
