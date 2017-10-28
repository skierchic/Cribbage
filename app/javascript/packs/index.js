import React from 'react';
import ReactDOM from 'react-dom';
import Cribbage from '../react/src/Cribbage';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<Cribbage />, document.getElementById('app'));
})
