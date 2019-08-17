import React, { useState } from "react"

const PlayerOpponents = (props) => {
  const [collapsed, setCollapsed] = useState(true)
  const [count, setCount] = useState(5)
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
    return (b.wins + b.losses) - (a.wins + a.losses)
  })
  if (collapsed && opponentsArray.length >= count) {
    for (var i = 0; i < count; i++) {
      rows.push(
        <tr key={opponentsArray[i].id}>
          <td><a href={`/player/${opponentsArray[i].id}`}>{opponentsArray[i].name}</a></td>
          <td>{opponentsArray[i].wins}</td>
          <td>{opponentsArray[i].losses}</td>
          <td>{opponentsArray[i].spread}</td>
          <td>{opponentsArray[i].rating}</td>
        </tr>
      )
    }
  }
  else{
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
  }
  return(
    <div className="player-opponentsWrapper">
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
      {opponentsArray.length >= count ? <button onClick={() => {setCollapsed(!collapsed)}}>{collapsed ? "expand" : "collapse"}</button> : null}
    </div>
  )
}

export default PlayerOpponents
