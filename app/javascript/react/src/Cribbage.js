import React from 'react';
import { Router } from 'react-router';
import GameIndexContainer from './container/GameIndexContainer'

const Cribbage = props => {
  return(
    <Router>
      <Route path='/' component={GameIndexContainer}/>
    </Router>
  )
}

export default Cribbage
