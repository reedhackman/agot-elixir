import React, { Component } from "react"

const PlayerOpponents = (props) => {
  let opponents = {}
  let opponentsArray = []
  let rows = []
  props.wins.forEach((game) => {
    if(!(opponents[game.opponent_id])){
      opponents[game.opponent_id] = {
        name: game.opponent_name,
        rating: game.opponent_rating,
        wins: 0,
        losses: 0
      }
    }
    opponents[game.opponent_id].wins++
  })
  props.losses.forEach((game) => {
    if(!(opponents[game.opponent_id])){
      opponents[game.opponent_id] = {
        name: game.opponent_name,
        rating: game.opponent_rating,
        wins: 0,
        losses: 0
      }
    }
    opponents[game.opponent_id].losses++
  })
  for (let id in opponents) {
    opponentsArray.push({
      id: id,
      name: opponents[id].name,
      wins: opponents[id].wins,
      losses: opponents[id].losses,
      spread: opponents[id].wins - opponents[id].losses,
      rating: opponents[id].rating
    })
  }
  opponentsArray.sort((a, b) => {
    if (a.name > b.name) {
      return 1
    }
    else if(a.name < b.name){
      return -1
    }
    return 0
  })
  opponentsArray.forEach((opponent) => {
    rows.push(
      <tr key={opponent.id}>
        <td><a href={`/player/${opponent.id}`}>{opponent.name}</a></td>
        <td>{opponent.wins}</td>
        <td>{opponent.losses}</td>
        <td>{opponent.spread}</td>
        <td>{opponent.rating}</td>
      </tr>
    )
  })

  return(
    <div className="opponentsWrapper">
      <h1>Opponents</h1>
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Wins</th>
            <th>Losses</th>
            <th>Spread</th>
            <th>Rating</th>
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </table>
    </div>
  )
}

export default PlayerOpponents
