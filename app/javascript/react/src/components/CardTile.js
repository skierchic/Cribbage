import React from 'react'

const CardTile = (props) => {
  return(
    <div className={props.className} onClick={props.onClick}>
      <img src={props.image} />
      {/* <p>{props.name}</p> */}
    </div>
  )
}

export default CardTile

//
// <img src={props.image} height="600" width="400" />
// <img src={props.image} height="600" width="400" />
