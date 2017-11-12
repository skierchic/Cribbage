import React from 'react'

const GoButton = props => {
  let display = props.show ? '' : 'hide'
  return(
    <div className='display_button'>
      <div className={`game_tile new_game ${display}`} onClick={props.handleClick}>
        Go
      </div>      
    </div>
  )
}

export default GoButton
