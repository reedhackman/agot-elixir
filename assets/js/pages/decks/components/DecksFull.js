import React, { useState, useEffect } from 'react'
import { A } from 'hookrouter'

const DecksFull = (props) => {
  const [decks, setDecks] = useState({})

  useEffect(() => {
    let decksObject = {}
    props.games.forEach((game) => {
      if(!(decksObject[game.winner_faction])){
        decksObject[game.winner_faction] = {
          [game.winner_agenda]: {
            wins: 0,
            losses: 0
          }
        }
      }
      else if(!(decksObject[game.winner_faction][game.winner_agenda])){
        decksObject[game.winner_faction][game.winner_agenda] = {
          wins: 0,
          losses: 0
        }
      }
      if(!(decksObject[game.loser_faction])){
        decksObject[game.loser_faction] = {
          [game.loser_agenda]: {
            wins: 0,
            losses: 0
          }
        }
      }
      else if(!(decksObject[game.loser_faction][game.loser_agenda])){
        decksObject[game.loser_faction][game.loser_agenda] = {
          wins: 0,
          losses: 0
        }
      }
      decksObject[game.winner_faction][game.winner_agenda].wins++
      decksObject[game.loser_faction][game.loser_agenda].losses++
    })
    setDecks(decksObject)
  }, [props.games])

  let decksArray = []
  let rows = []
  for(let faction in decks){
    for(let agenda in decks[faction]){
      let deck = decks[faction][agenda]
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
    if((deck.wins + deck.losses) >= props.min){
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

export default DecksFull
