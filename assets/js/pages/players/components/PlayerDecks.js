import React, { useState } from "react";

const PlayerDecks = props => {
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

  let decks = {};
  let decksArray = [];
  let rows = [];

  props.wins.forEach(game => {
    if (game.winner_faction && game.winner_agenda) {
      if (!decks[game.winner_faction]) {
        if (game.winner_agenda) {
          decks[game.winner_faction] = {
            [game.winner_agenda]: {
              wins: 0,
              losses: 0
            }
          };
        }
      } else if (!decks[game.winner_faction][game.winner_agenda]) {
        decks[game.winner_faction][game.winner_agenda] = {
          wins: 0,
          losses: 0
        };
      }
      decks[game.winner_faction][game.winner_agenda].wins++;
    }
  });

  props.losses.forEach(game => {
    if (game.loser_faction && game.loser_agenda) {
      if (!decks[game.loser_faction]) {
        if (game.loser_agenda) {
          decks[game.loser_faction] = {
            [game.loser_agenda]: {
              wins: 0,
              losses: 0
            }
          };
        }
      } else if (!decks[game.loser_faction][game.loser_agenda]) {
        decks[game.loser_faction][game.loser_agenda] = {
          wins: 0,
          losses: 0
        };
      }
      decks[game.loser_faction][game.loser_agenda].losses++;
    }
  });

  for (let faction in decks) {
    for (let agenda in decks[faction]) {
      decksArray.push({
        faction: faction,
        agenda: agenda,
        wins: decks[faction][agenda].wins,
        losses: decks[faction][agenda].losses,
        played: decks[faction][agenda].wins + decks[faction][agenda].losses,
        percent:
          decks[faction][agenda].wins /
          (decks[faction][agenda].wins + decks[faction][agenda].losses)
      });
    }
  }
  decksArray.sort((a, b) => {
    if (!asc) {
      if (sortBy === "faction" || sortBy === "agenda") {
        if (a[sortBy] > b[sortBy]) {
          return 1;
        }
        if (b[sortBy] > a[sortBy]) {
          return -1;
        }
        return 0;
      }
      return b[sortBy] - a[sortBy];
    }
    if (sortBy === "faction" || sortBy === "agenda") {
      if (a[sortBy] > b[sortBy]) {
        return -1;
      }
      if (b[sortBy] > a[sortBy]) {
        return 1;
      }
      return 0;
    }
    return a[sortBy] - b[sortBy];
  });

  if (collapsed && decksArray.length >= count) {
    for (var i = 0; i < count; i++) {
      rows.push(
        <tr key={decksArray[i].faction + decksArray[i].agenda}>
          <td>
            <a href={`/deck/${decksArray[i].faction}`}>
              {decksArray[i].faction}
            </a>
          </td>
          <td>
            <a href={`/deck/${decksArray[i].faction}/${decksArray[i].agenda}`}>
              {decksArray[i].agenda}
            </a>
          </td>
          <td>{decksArray[i].played}</td>
          <td>{decksArray[i].percent}</td>
        </tr>
      );
    }
  } else {
    decksArray.forEach(deck => {
      rows.push(
        <tr key={deck.faction + deck.agenda}>
          <td>
            <a href={`/deck/${deck.faction}`}>{deck.faction}</a>
          </td>
          <td>
            <a href={`/deck/${deck.faction}/${deck.agenda}`}>{deck.agenda}</a>
          </td>
          <td>{deck.played}</td>
          <td>{deck.percent}</td>
        </tr>
      );
    });
  }

  return (
    <div className="player-decksWrapper">
      <h1>Decks</h1>
      <table>
        <thead>
          <tr>
            {sortBy === "faction" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("faction")}
                >
                  {asc ? (
                    <i className="la la-sort-alpha-asc"></i>
                  ) : (
                    <i className="la la-sort-alpha-desc"></i>
                  )}
                  faction
                </div>
              </th>
            ) : (
              <th>
                <div
                  className="reactButton"
                  onClick={() => handleSort("faction")}
                >
                  faction
                </div>
              </th>
            )}
            {sortBy === "agenda" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("agenda")}
                >
                  {asc ? (
                    <i className="la la-sort-alpha-asc"></i>
                  ) : (
                    <i className="la la-sort-alpha-desc"></i>
                  )}
                  agenda
                </div>
              </th>
            ) : (
              <th>
                <div
                  className="reactButton"
                  onClick={() => handleSort("agenda")}
                >
                  agenda
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
                  played
                </div>
              </th>
            ) : (
              <th>
                <div
                  className="reactButton"
                  onClick={() => handleSort("played")}
                >
                  played
                </div>
              </th>
            )}
            {sortBy === "percent" ? (
              <th>
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("percent")}
                >
                  {asc ? (
                    <i className="la la-sort-numeric-asc"></i>
                  ) : (
                    <i className="la la-sort-numeric-desc"></i>
                  )}
                  percent
                </div>
              </th>
            ) : (
              <th>
                <div
                  className="reactButton"
                  onClick={() => handleSort("percent")}
                >
                  percent
                </div>
              </th>
            )}
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </table>
      {decksArray.length >= count ? (
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

export default PlayerDecks;
