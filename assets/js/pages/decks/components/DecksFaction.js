import React, { useState, useEffect } from "react";
import { A } from "hookrouter";

const DecksFaction = props => {
  const [decks, setDecks] = useState({});
  const [asc, setAsc] = useState(false);
  const [sortBy, setSortBy] = useState("percent");
  const handleSort = newSort => {
    if (newSort === sortBy) {
      setAsc(!asc);
    } else {
      setAsc(false);
      setSortBy(newSort);
    }
  };

  useEffect(() => {
    let decksObject = {};
    props.games.forEach(game => {
      if (game.winner_faction == props.faction) {
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
        decksObject[game.winner_faction][game.winner_agenda].wins++;
      } else if (game.loser_faction == props.faction) {
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
        decksObject[game.loser_faction][game.loser_agenda].losses++;
      }
    });
    setDecks(decksObject);
  }, [props.games, props.faction]);
  let rows = [];
  let decksArray = [];
  for (let faction in decks) {
    for (let agenda in decks[faction]) {
      let deck = decks[faction][agenda];
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
  decksArray.forEach(deck => {
    if (deck.wins + deck.losses >= props.min) {
      rows.push(
        <tr key={deck.faction + deck.agenda}>
          <td>
            <A href={`/react/deck/${deck.faction}/${deck.agenda}`}>
              {deck.agenda}
            </A>
          </td>
          <td>{deck.wins / (deck.wins + deck.losses)}</td>
          <td>{deck.wins + deck.losses}</td>
        </tr>
      );
    }
  });
  return (
    <div>
      <A href="/react/deck">ALL DECKS</A>
      <h2>
        {props.faction} {props.agenda}
      </h2>
      <table>
        <thead>
          <tr>
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
    </div>
  );
};

export default DecksFaction;
