import React, { useState } from "react";
const moment = require("moment");

const PlayerTournaments = props => {
  const [collapsed, setCollapsed] = useState(true);
  const [count, setCount] = useState(5);
  const [sortBy, setSortBy] = useState("date");
  const [asc, setAsc] = useState(false);
  let tournamentsArray = [...props.tournaments];
  let rows = [];
  const handleSort = newSort => {
    if (newSort === sortBy) {
      setAsc(!asc);
    } else {
      setAsc(false);
      setSortBy(newSort);
    }
  };
  tournamentsArray.sort((a, b) => {
    if (!asc) {
      if (sortBy === "name") {
        if (a[sortBy].toLowerCase() > b[sortBy].toLowerCase()) {
          return 1;
        }
        if (b[sortBy].toLowerCase() > a[sortBy].toLowerCase()) {
          return -1;
        }
        return 0;
      } else if (sortBy === "date") {
        return new Date(b.date) - new Date(a.date);
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
    } else if (sortBy === "date") {
      return new Date(a.date) - new Date(b.date);
    }
    return a[sortBy] - b[sortBy];
  });
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
            {sortBy === "date" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("date")}
                >
                  {asc ? (
                    <i className="la la-sort-asc"></i>
                  ) : (
                    <i className="la la-sort-desc"></i>
                  )}
                  date
                </div>
              </th>
            ) : (
              <th>
                <div className="reactButton" onClick={() => handleSort("date")}>
                  date
                </div>
              </th>
            )}
            {sortBy === "placement" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("placement")}
                >
                  {asc ? (
                    <i className="la la-sort-asc"></i>
                  ) : (
                    <i className="la la-sort-desc"></i>
                  )}
                  placement
                </div>
              </th>
            ) : (
              <th>
                <div
                  className="reactButton"
                  onClick={() => handleSort("placement")}
                >
                  placement
                </div>
              </th>
            )}
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </table>
      {tournamentsArray.length >= count ? (
        <div
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

export default PlayerTournaments;
