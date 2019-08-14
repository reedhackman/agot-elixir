import React from 'react'
import { Link } from "react-router-dom";

export default class extends React.Component{
  constructor(props){
    super(props)
    this.state = {
      games: [],
      decks: {},
    }
  }
  componentDidMount() {
    let games = this.props.games
    let decks = {}
    games.forEach((game) => {
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
  }
  componentWillReceiveProps({games}) {
    let decks = {}
    games.forEach((game) => {
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
  }

  render(){
    let decksArray = []
    let rows = []
    for(let faction in this.state.decks){
      for(let agenda in this.state.decks[faction]){
        let deck = this.state.decks[faction][agenda]
        decksArray.push({
          faction: faction,
          agenda: agenda,
          wins: deck.wins,
          losses: deck.losses
        })
      }
    }
    decksArray.sort((a,b) => {
      return (b.wins / (b.wins + b.losses)) - (a.wins / (a.wins + a.losses))
    })
    decksArray.forEach((deck) => {
      rows.push(
        <tr key={deck.faction + deck.agenda}>
          <td><Link to={`/react/deck/${deck.faction}/${deck.agenda}`}>{deck.faction}</Link></td>
          <td>{deck.agenda}</td>
          <td>{deck.wins / (deck.wins + deck.losses)}</td>
          <td>{deck.wins + deck.losses}</td>
        </tr>
      )
    })
    return(
      <div>
        <h2>All Decks</h2>
        <table>
          <thead>
            <tr>
              <th>Faction</th>
              <th>Agenda</th>
              <th>Win %</th>
              <th>Games Played</th>
            </tr>
          </thead>
          <tbody>
            {rows}
          </tbody>
        </table>
      </div>
    )
  }
}
