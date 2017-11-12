import React from 'react'

const NewGameButton = props => {
  return(
    <div className='display_button'>
      <div className='game_tile new_game' onClick={props.handleClick}>
        Start a New Game
      </div>
    </div>
  )
}

export default NewGameButton
