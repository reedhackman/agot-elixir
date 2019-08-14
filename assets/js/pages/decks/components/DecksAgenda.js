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
  componentWillReceiveProps({games}) {
    let matchups = {}
    console.log(this.props.match.params.faction)
    console.log(this.props.match.params.agenda)
    games.forEach((game) => {
      if (game.winner_faction == this.props.match.params.faction && game.winner_agenda == this.props.match.params.agenda) {
        if (!(matchups[game.loser_faction])) {
          matchups[game.loser_faction] = {
            [game.loser_agenda]: {
              wins: 0,
              losses: 0
            }
          }
        }
        else if (!(matchups[game.loser_faction][game.loser_agenda])) {
          matchups[game.loser_faction][game.loser_agenda] = {
            wins: 0,
            losses: 0
          }
        }
        matchups[game.loser_faction][game.loser_agenda].wins++
      }
      else if (game.loser_faction == this.props.match.params.faction && game.loser_agenda == this.props.match.params.agenda) {
        if (!(matchups[game.winner_faction])) {
          matchups[game.winner_faction] = {
            [game.winner_agenda]: {
              wins: 0,
              losses: 0
            }
          }
        }
        else if (!(matchups[game.winner_faction][game.winner_agenda])) {
          matchups[game.winner_faction][game.winner_agenda] = {
            wins: 0,
            losses: 0
          }
        }
        matchups[game.winner_faction][game.winner_agenda].losses++
      }
    })
    this.setState({
      matchups: matchups
    })
  }
  render(){
    let rows = []
    let matchupsArray = []
    for(let faction in this.state.matchups){
      for(let agenda in this.state.matchups[faction]){
        matchupsArray.push({
          faction: faction,
          agenda: agenda,
          wins: this.state.matchups[faction][agenda].wins,
          losses: this.state.matchups[faction][agenda].losses
        })
      }
    }
    matchupsArray.sort((a,b) => {
      return (b.wins / (b.wins + b.losses)) - (a.wins / (a.wins + a.losses))
    })
    matchupsArray.forEach((deck) => {
      if (deck.wins + deck.losses >= this.props.min) {
        rows.push(
          <tr key={deck.faction + deck.agenda}>
            <td><Link to={`/react/deck/${deck.faction}/${deck.agenda}`}>{deck.faction}</Link></td>
            <td>{deck.agenda}</td>
            <td>{deck.wins / (deck.wins + deck.losses)}</td>
            <td>{deck.wins + deck.losses}</td>
          </tr>
        )
      }
    })
    return(
      <div>
        <h2>{this.props.match.params.faction} {this.props.match.params.agenda}</h2>
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
