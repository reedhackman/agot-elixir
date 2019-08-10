import React, { Component } from "react"

const PlayerDecks = (props) => {
  let decks = {}
  let decksArray = []
  let rows = []
  props.wins.forEach((game) => {
    if (game.winner_faction && game.winner_agenda) {
      if (!(decks[game.winner_faction])) {
        if (game.winner_agenda) {
          decks[game.winner_faction] = {
            [game.winner_agenda]: {
              wins: 0,
              losses: 0
            }
          }
        }
      }
      else if (!(decks[game.winner_faction][game.winner_agenda])) {
        decks[game.winner_faction][game.winner_agenda] = {
          wins: 0,
          losses: 0
        }
      }
      decks[game.winner_faction][game.winner_agenda].wins++
    }
  })
  props.losses.forEach((game) => {
    if (game.loser_faction && game.loser_agenda) {
      if (!(decks[game.loser_faction])) {
        if (game.loser_agenda) {
          decks[game.loser_faction] = {
            [game.loser_agenda]: {
              wins: 0,
              losses: 0
            }
          }
        }
      }
      else if (!(decks[game.loser_faction][game.loser_agenda])) {
        decks[game.loser_faction][game.loser_agenda] = {
          wins: 0,
          losses: 0
        }
      }
      decks[game.loser_faction][game.loser_agenda].losses++
    }
  })
  for(let faction in decks){
    for(let agenda in decks[faction]){
      decksArray.push({faction: faction, agenda: agenda, wins: decks[faction][agenda].wins, losses: decks[faction][agenda].losses})
    }
  }
  decksArray.sort((a, b) => {
    if (a.agenda > b.agenda) {
      return 1
    }
    else if(a.agenda < b.agenda){
      return -1
    }
    return 0
  })
  decksArray.sort((a, b) => {
    if (a.faction > b.faction) {
      return 1
    }
    else if(a.faction < b.faction){
      return -1
    }
    return 0
  })
  decksArray.forEach((deck) => {
    rows.push(
      <tr key={deck.faction + deck.agenda}>
        <td>{deck.faction}</td>
        <td>{deck.agenda}</td>
        <td>{deck.wins}</td>
        <td>{deck.losses}</td>
      </tr>
    )
  })
  return(
    <div className="decksWrapper">
      <h1>Decks</h1>
      <table>
        <thead>
          <tr>
            <th>Faction</th>
            <th>Agenda</th>
            <th>Wins</th>
            <th>Losses</th>
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </table>
    </div>
  )
}

export default PlayerDecks
