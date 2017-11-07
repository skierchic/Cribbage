import React from 'react'

const GoButton = props => {
  let display = ''
  return(
    <div className={`game_tile new_game ${display}`} onClick={props.handleClick}>
      Go
    </div>
  )
}

export default GoButton
