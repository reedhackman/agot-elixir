import React, { useState } from "react";
const moment = require("moment");

const PlayerTournaments = props => {
  const [collapsed, setCollapsed] = useState(true);
  const [count, setCount] = useState(5);
  let tournamentsArray = [...props.tournaments];
  let rows = [];
  if (collapsed && tournamentsArray.length >= count) {
    for (var i = 0; i < count; i++) {
      rows.push(
        <tr key={tournamentsArray[i].id}>
          <td>
            <a
              target="_blank"
              href={`https://thejoustingpavilion.com/tournaments/${tournamentsArray[i].id}`}
            >
              {tournamentsArray[i].name}
            </a>
          </td>
          <td>
            {moment(tournamentsArray[i].date)
              .local()
              .format("YYYY-MM-DD")}
          </td>
          <td>Coming Soon</td>
        </tr>
      );
    }
  } else {
    tournamentsArray.forEach(tournament => {
      rows.push(
        <tr key={tournament.id}>
          <td>
            <a
              href={`https://thejoustingpavilion.com/tournaments/${tournament.id}`}
            >
              {tournament.name}
            </a>
          </td>
          <td>
            {moment(tournament.date)
              .local()
              .format("YYYY-MM-DD")}
          </td>
          <td>Coming Soon</td>
        </tr>
      );
    });
  }
  console.log(tournamentsArray);
  return (
    <div className="player-tournamentsWrapper">
      <h1>Tournaments</h1>
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Date</th>
            <th>Place</th>
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </table>
      {tournamentsArray.length >= count ? (
        <button
          onClick={() => {
            setCollapsed(!collapsed);
          }}
        >
          {collapsed ? "expand" : "collapse"}
        </button>
      ) : null}
    </div>
  );
};

export default PlayerTournaments;
