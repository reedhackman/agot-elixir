import React from 'react'

export default class extends React.Component{
  constructor(props){
    super(props)
    this.state = {
      games: this.props.games,
      decks: {},
    }
  }
  componentDidMount(){
    let decks = {}
    this.props.games.forEach((game) => {
      if(!(decks[game.winner_faction])){
        decks[game.winner_faction] = {
          [game.winner_agenda]: {
            wins: 0,
            losses: 0
          }
        }
      }
      else if(!(decks[game.winner_faction][game.winner_agenda])){
        decks[game.winner_faction][game.winner_agenda] = {
          wins: 0,
          losses: 0
        }
      }
      if(!(decks[game.loser_faction])){
        decks[game.loser_faction] = {
          [game.loser_agenda]: {
            wins: 0,
            losses: 0
          }
        }
      }
      else if(!(decks[game.loser_faction][game.loser_agenda])){
        decks[game.loser_faction][game.loser_agenda] = {
          wins: 0,
          losses: 0
        }
      }
      decks[game.winner_faction][game.winner_agenda].wins++
      decks[game.loser_faction][game.loser_agenda].losses++
    })
    this.setState({
      decks: decks
    })
    for(let faction in decks){
      this.setState({
        [faction]: decks[faction]
      })
    }
  }
  render(){
    console.log(this.state.decks)
    return(
      <div>{this.props.games.length}</div>
    )
  }
}
