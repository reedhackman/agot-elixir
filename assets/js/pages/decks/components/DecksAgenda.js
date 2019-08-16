import React, { useState, useEffect } from 'react'
import { A } from 'hookrouter'

const DecksAgenda = (props) => {
  const [decks, setDecks] = useState({})
  const [matchups, setMatchups] = useState({})

  useEffect(() => {
    let matchupsObject = {}
    props.games.forEach((game) => {
      if (game.winner_faction == props.faction && game.winner_agenda == props.agenda) {
        if (!(matchupsObject[game.loser_faction])) {
          matchupsObject[game.loser_faction] = {
            [game.loser_agenda]: {
              wins: 0,
              losses: 0
            }
          }
        }
        else if (!(matchupsObject[game.loser_faction][game.loser_agenda])) {
          matchupsObject[game.loser_faction][game.loser_agenda] = {
            wins: 0,
            losses: 0
          }
        }
        matchupsObject[game.loser_faction][game.loser_agenda].wins++
      }
      else if (game.loser_faction == props.faction && game.loser_agenda == props.agenda) {
        if (!(matchupsObject[game.winner_faction])) {
          matchupsObject[game.winner_faction] = {
            [game.winner_agenda]: {
              wins: 0,
              losses: 0
            }
          }
        }
        else if (!(matchupsObject[game.winner_faction][game.winner_agenda])) {
          matchupsObject[game.winner_faction][game.winner_agenda] = {
            wins: 0,
            losses: 0
          }
        }
        matchupsObject[game.winner_faction][game.winner_agenda].losses++
      }
    })
    setMatchups(matchupsObject)
  }, [props.games, props.faction, props.agenda])

  let rows = []
  let matchupsArray = []
  for(let faction in matchups){
    for(let agenda in matchups[faction]){
      matchupsArray.push({
        faction: faction,
        agenda: agenda,
        wins: matchups[faction][agenda].wins,
        losses: matchups[faction][agenda].losses
      })
    }
  }
  matchupsArray.sort((a,b) => {
    return (b.wins / (b.wins + b.losses)) - (a.wins / (a.wins + a.losses))
  })
  matchupsArray.forEach((deck) => {
    if(deck.wins + deck.losses >= props.min){
      rows.push(
        <tr key={deck.faction + deck.agenda}>
          <td><A href={`/react/deck/${deck.faction}/${deck.agenda}`}>{deck.faction}</A></td>
          <td>{deck.agenda}</td>
          <td>{deck.wins / (deck.wins + deck.losses)}</td>
          <td>{deck.wins + deck.losses}</td>
        </tr>
      )
    }
  })
  return(
    <div>
      <A href="/react/deck">ALL DECKS</A>
      <h2>{props.faction} {props.agenda}</h2>
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

export default DecksAgenda
