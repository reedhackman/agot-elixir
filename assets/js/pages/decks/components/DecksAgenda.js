import React, { useState, useEffect } from "react";
import { A } from "hookrouter";

const DecksAgenda = props => {
  const [matchups, setMatchups] = useState({});
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
    let matchupsObject = {};
    props.games.forEach(game => {
      if (
        game.winner_faction == props.faction &&
        game.winner_agenda == props.agenda
      ) {
        if (!matchupsObject[game.loser_faction]) {
          matchupsObject[game.loser_faction] = {
            [game.loser_agenda]: {
              wins: 0,
              losses: 0
            }
          };
        } else if (!matchupsObject[game.loser_faction][game.loser_agenda]) {
          matchupsObject[game.loser_faction][game.loser_agenda] = {
            wins: 0,
            losses: 0
          };
        }
        matchupsObject[game.loser_faction][game.loser_agenda].wins++;
      } else if (
        game.loser_faction == props.faction &&
        game.loser_agenda == props.agenda
      ) {
        if (!matchupsObject[game.winner_faction]) {
          matchupsObject[game.winner_faction] = {
            [game.winner_agenda]: {
              wins: 0,
              losses: 0
            }
          };
        } else if (!matchupsObject[game.winner_faction][game.winner_agenda]) {
          matchupsObject[game.winner_faction][game.winner_agenda] = {
            wins: 0,
            losses: 0
          };
        }
        matchupsObject[game.winner_faction][game.winner_agenda].losses++;
      }
    });
    setMatchups(matchupsObject);
  }, [props.games, props.faction, props.agenda]);

  let rows = [];
  let matchupsArray = [];
  for (let faction in matchups) {
    for (let agenda in matchups[faction]) {
      matchupsArray.push({
        faction: faction,
        agenda: agenda,
        wins: matchups[faction][agenda].wins,
        losses: matchups[faction][agenda].losses,
        played:
          matchups[faction][agenda].wins + matchups[faction][agenda].losses,
        percent:
          matchups[faction][agenda].wins /
          (matchups[faction][agenda].wins + matchups[faction][agenda].losses)
      });
    }
  }
  matchupsArray.sort((a, b) => {
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
  console.log(sortBy);
  matchupsArray.forEach(deck => {
    if (deck.wins + deck.losses >= props.min) {
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
    </div>
  );
};

export default DecksAgenda;
