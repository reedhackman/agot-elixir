import React, { useState } from "react";

const PlayerOpponents = props => {
  const [collapsed, setCollapsed] = useState(true);
  const [count, setCount] = useState(5);
  const [sortBy, setSortBy] = useState("played");
  const [asc, setAsc] = useState(false);

  const handleSort = newSort => {
    if (newSort === sortBy) {
      setAsc(!asc);
    } else {
      setAsc(false);
      setSortBy(newSort);
    }
  };

  let opponents = {};
  let opponentsArray = [];
  let rows = [];

  props.wins.forEach(game => {
    if (!opponents[game.opponent_id]) {
      opponents[game.opponent_id] = {
        name: game.opponent_name,
        rating: game.opponent_rating,
        wins: 0,
        losses: 0
      };
    }
    opponents[game.opponent_id].wins++;
  });

  props.losses.forEach(game => {
    if (!opponents[game.opponent_id]) {
      opponents[game.opponent_id] = {
        name: game.opponent_name,
        rating: game.opponent_rating,
        wins: 0,
        losses: 0
      };
    }
    opponents[game.opponent_id].losses++;
  });

  for (let id in opponents) {
    opponentsArray.push({
      id: id,
      name: opponents[id].name,
      wins: opponents[id].wins,
      played: opponents[id].wins + opponents[id].losses,
      losses: opponents[id].losses,
      spread: opponents[id].wins - opponents[id].losses,
      rating: opponents[id].rating
    });
  }

  opponentsArray.sort((a, b) => {
    if (!asc) {
      if (sortBy === "name") {
        if (a[sortBy].toLowerCase() > b[sortBy].toLowerCase()) {
          return 1;
        }
        if (b[sortBy].toLowerCase() > a[sortBy].toLowerCase()) {
          return -1;
        }
        return 0;
      }
      return b[sortBy] - a[sortBy];
    }
    if (sortBy === "name") {
      if (a[sortBy].toLowerCase() > b[sortBy].toLowerCase()) {
        return -1;
      }
      if (b[sortBy].toLowerCase() > a[sortBy].toLowerCase()) {
        return 1;
      }
      return 0;
    }
    return a[sortBy] - b[sortBy];
  });

  if (collapsed && opponentsArray.length >= count) {
    for (var i = 0; i < count; i++) {
      rows.push(
        <tr key={opponentsArray[i].id}>
          <td>
            <a href={`/player/${opponentsArray[i].id}`}>
              {opponentsArray[i].name}
            </a>
          </td>
          <td>{opponentsArray[i].wins + opponentsArray[i].losses}</td>
          <td>
            <b>{`${opponentsArray[i].spread}`}</b>
            {` (${opponentsArray[i].wins}W, ${opponentsArray[i].losses}L)`}
          </td>
          <td>{opponentsArray[i].rating}</td>
        </tr>
      );
    }
  } else {
    opponentsArray.forEach(opponent => {
      rows.push(
        <tr key={opponent.id}>
          <td>
            <a href={`/player/${opponent.id}`}>{opponent.name}</a>
          </td>
          <td>{opponent.wins + opponent.losses}</td>
          <td>
            <b>{`${opponent.spread}`}</b>
            {` (${opponent.wins}W, ${opponent.losses}L)`}
          </td>
          <td>{opponent.rating}</td>
        </tr>
      );
    });
  }

  return (
    <div className="player-opponentsWrapper">
      <h1>Opponents</h1>
      <table>
        <thead>
          <tr>
            {sortBy === "name" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("name")}
                >
                  {asc ? (
                    <i className="la la-sort-alpha-asc"></i>
                  ) : (
                    <i className="la la-sort-alpha-desc"></i>
                  )}
                  Name
                </div>
              </th>
            ) : (
              <th>
                <div className="reactButton" onClick={() => handleSort("name")}>
                  Name
                </div>
              </th>
            )}
            {sortBy === "played" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("played")}
                >
                  {asc ? (
                    <i className="la la-sort-numeric-asc"></i>
                  ) : (
                    <i className="la la-sort-numeric-desc"></i>
                  )}
                  Played
                </div>
              </th>
            ) : (
              <th>
                <div
                  className="reactButton"
                  onClick={() => handleSort("played")}
                >
                  Played
                </div>
              </th>
            )}
            {sortBy === "spread" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("spread")}
                >
                  {asc ? (
                    <i className="la la-sort-numeric-asc"></i>
                  ) : (
                    <i className="la la-sort-numeric-desc"></i>
                  )}
                  Spread
                </div>
              </th>
            ) : (
              <th>
                <div
                  className="reactButton"
                  onClick={() => handleSort("spread")}
                >
                  Spread
                </div>
              </th>
            )}
            {sortBy === "rating" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("rating")}
                >
                  {asc ? (
                    <i className="la la-sort-numeric-asc"></i>
                  ) : (
                    <i className="la la-sort-numeric-desc"></i>
                  )}
                  Rating
                </div>
              </th>
            ) : (
              <th>
                <div
                  className="reactButton"
                  onClick={() => handleSort("rating")}
                >
                  Rating
                </div>
              </th>
            )}
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </table>
      {opponentsArray.length >= count ? (
        <div
          className="reactButton"
          onClick={() => {
            setCollapsed(!collapsed);
          }}
        >
          {collapsed ? (
            <i className="la la-caret-square-o-down"></i>
          ) : (
            <i className="la la-caret-square-o-up"></i>
          )}
          {collapsed ? "expand" : "collapse"}
        </div>
      ) : null}
    </div>
  );
};

export default PlayerOpponents;
