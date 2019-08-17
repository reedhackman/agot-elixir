import React, { useState } from 'react'

const PlayerTournaments = (props) => {
  const [collapsed, setCollapsed] = useState(true)
  const [count, setCount] = useState(5)
  let tournamentsArray = []
  let rows = []
  return(
    <div className="player-tournamentsWrapper">
      <h1>Tournaments - Coming Soon</h1>
      {/*
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Date</th>
            <th>Place</th>
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </table>
      {tournamentsArray.length >= count ? <button onClick={() => {setCollapsed(!collapsed)}}>{collapsed ? "expand" : "collapse"}</button> : null}
      */}
    </div>
  )
}

export default PlayerTournaments
