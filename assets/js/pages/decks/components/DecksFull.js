import React, { useState, useEffect } from "react";
import { A } from "hookrouter";

const DecksFull = props => {
  const [decks, setDecks] = useState([]);
  const [asc, setAsc] = useState(false);
  const [sortBy, setSortBy] = useState("percent");
  const [page, setPage] = useState(0);
  const [last, setLast] = useState(0);
  const handleSort = newSort => {
    if (newSort === sortBy) {
      setAsc(!asc);
    } else {
      setAsc(false);
      setSortBy(newSort);
    }
  };
  const handlePage = newPage => {
    setPage(newPage);
  };
  useEffect(() => {
    let decksObject = {};
    props.games.forEach(game => {
      if (!decksObject[game.winner_faction]) {
        decksObject[game.winner_faction] = {
          [game.winner_agenda]: {
            wins: 0,
            losses: 0
          }
        };
      } else if (!decksObject[game.winner_faction][game.winner_agenda]) {
        decksObject[game.winner_faction][game.winner_agenda] = {
          wins: 0,
          losses: 0
        };
      }
      if (!decksObject[game.loser_faction]) {
        decksObject[game.loser_faction] = {
          [game.loser_agenda]: {
            wins: 0,
            losses: 0
          }
        };
      } else if (!decksObject[game.loser_faction][game.loser_agenda]) {
        decksObject[game.loser_faction][game.loser_agenda] = {
          wins: 0,
          losses: 0
        };
      }
      decksObject[game.winner_faction][game.winner_agenda].wins++;
      decksObject[game.loser_faction][game.loser_agenda].losses++;
    });
    var decksArray = [];
    for (let faction in decksObject) {
      for (let agenda in decksObject[faction]) {
        let deck = decksObject[faction][agenda];
        if (deck.wins + deck.losses >= props.min) {
          decksArray.push({
            faction: faction,
            agenda: agenda,
            wins: deck.wins,
            losses: deck.losses,
            played: deck.wins + deck.losses,
            percent: deck.wins / (deck.wins + deck.losses)
          });
        }
      }
    }

    setDecks(decksArray);
    setPage(1);
    setLast(Math.ceil(decksArray.length / 15));
  }, [props.games, props.min]);
  let decksArray = decks;
  let rows = [];
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
  let j = Math.max((page - 1) * 15, 0);
  let k = decksArray.length - j;
  for (let i = 0; i < Math.min(k, 15); i++) {
    let deck = decksArray[j];
    rows.push(
      <tr key={deck.faction + deck.agenda}>
        <td>
          <A href={`/react/deck/${deck.faction}`}>{deck.faction}</A>
        </td>
        <td>
          <A href={`/react/deck/${deck.faction}/${deck.agenda}`}>
            {deck.agenda}
          </A>
        </td>
        <td>{deck.wins / (deck.wins + deck.losses)}</td>
        <td>{deck.wins + deck.losses}</td>
      </tr>
    );
    j++;
  }
  const nav = (
    <div className="navbuttons">
      {page === 1 ? null : (
        <div onClick={() => handlePage(1)} className="button-table button-left">
          First
        </div>
      )}
      {page === 1 ? null : (
        <div
          onClick={() => handlePage(page - 1)}
          className="button-table button-left"
        >
          Prev
        </div>
      )}
      <span>
        Page {page} of {last}
      </span>
      {page === last ? null : (
        <div
          onClick={() => handlePage(page + 1)}
          className="button-table button-right"
        >
          Next
        </div>
      )}
      {page === last ? null : (
        <div
          onClick={() => handlePage(last)}
          className="button-table button-right"
        >
          Last
        </div>
      )}
    </div>
  );
  return (
    <div>
      <h2>All Decks</h2>
      <table>
        <thead>
          <tr>
            <th>
              {sortBy === "faction" ? (
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("faction")}
                >
                  {asc ? (
                    <i className="la la-sort-alpha-asc"></i>
                  ) : (
                    <i className="la la-sort-alpha-desc"></i>
                  )}
                  Faction
                </div>
              ) : (
                <div
                  className="reactButton"
                  onClick={() => handleSort("faction")}
                >
                  Faction
                </div>
              )}
            </th>
            <th>
              {sortBy === "agenda" ? (
                <div
                  className="reactButton"
                  onClick={() => handleSort("agenda")}
                >
                  {asc ? (
                    <i className="la la-sort-alpha-asc"></i>
                  ) : (
                    <i className="la la-sort-alpha-desc"></i>
                  )}
                  Agenda
                </div>
              ) : (
                <div
                  className="reactButton"
                  onClick={() => handleSort("agenda")}
                >
                  Agenda
                </div>
              )}
            </th>
            <th>
              {sortBy === "percent" ? (
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("percent")}
                >
                  {asc ? (
                    <i className="la la-sort-numeric-asc"></i>
                  ) : (
                    <i className="la la-sort-numeric-desc"></i>
                  )}
                  Win %
                </div>
              ) : (
                <div
                  className="reactButton"
                  onClick={() => handleSort("percent")}
                >
                  Win %
                </div>
              )}
            </th>
            <th>
              {sortBy === "played" ? (
                <div
                  className="reactButtonPrimary"
                  onClick={() => handleSort("played")}
                >
                  {asc ? (
                    <i className="la la-sort-numeric-asc"></i>
                  ) : (
                    <i className="la la-sort-numeric-desc"></i>
                  )}
                  Games Played
                </div>
              ) : (
                <div
                  className="reactButton"
                  onClick={() => handleSort("played")}
                >
                  Games Played
                </div>
              )}
            </th>
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </table>
      <div className="table-nav-buttons">{nav}</div>
    </div>
  );
};

export default DecksFull;
