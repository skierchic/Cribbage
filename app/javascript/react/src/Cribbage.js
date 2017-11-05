import React from 'react';
import { Router, Route, browserHistory, IndexRoute } from 'react-router';
import GameIndexContainer from './containers/GameIndexContainer'

const Cribbage = props => {
  return(
    <Router history={browserHistory}>
      <Route path='/' component={GameIndexContainer}/>
    </Router>
  )
}

export default Cribbage
