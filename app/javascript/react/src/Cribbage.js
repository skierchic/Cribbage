import React from 'react';
import { Router, Route, browserHistory, IndexRoute } from 'react-router';
import GameIndexContainer from './containers/GameIndexContainer'
import GameShowContainer from './containers/GameShowContainer'

const Cribbage = props => {
  return(
    <Router history={browserHistory}>
      <Route path='/' component={GameIndexContainer}/>
      <Route path='/games/:id' component={GameShowContainer}/>
    </Router>
  )
}

export default Cribbage
