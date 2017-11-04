import React from 'react';

class GameIndexContainer extends React.Component{
  constructor(props) {
    super(props);
    this.state = {}
  }

  ComponentDidMount() {
    fetch('/api/v1/games')
    .then(response => {
      if (response.ok) {
        return response;
      } else {
        let errorMessage = `${response.status} (${response.statusText})`,
            error = new Error(errorMessage);
          throw(error);
      }
    })
    .then(response => response.json())
    .then(body => {
      debugger
    })
  }
  render() {

    return(
      <div>List of Cribbage Games </div>
    )
  }
}

export default GameIndexContainer;
