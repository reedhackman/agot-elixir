import React, { useState, useEffect } from "react";
import { useRoutes } from "hookrouter";
import DecksFull from "./DecksFull.js";
import DecksFaction from "./DecksFaction.js";
import DecksAgenda from "./DecksAgenda.js";
const moment = require("moment");

const DecksReact = props => {
  const [games, setGames] = useState([]);
  const [start, setStart] = useState(
    moment()
      .utc()
      .subtract(90, "day")
      .format("YYYY-MM-DD")
  );
  const [end, setEnd] = useState(
    moment()
      .utc()
      .format("YYYY-MM-DD")
  );
  const [min, setMin] = useState(20);

  useEffect(() => {
    async function fetchData() {
      const response = await fetch(
        `/api/games/range?start=${start}&end=${end}`
      );
      const data = await response.json();
      setGames(data.games);
    }
    fetchData();
  }, [start, end]);

  const routes = {
    "/react/deck": () => <DecksFull games={games} min={min} />,
    "/react/deck/:faction": ({ faction }) => (
      <DecksFaction
        faction={faction.replace(/%20/g, " ").replace(/%22/g, '"')}
        games={games}
        min={min}
      />
    ),
    "/react/deck/:faction/:agenda": ({ faction, agenda }) => (
      <DecksAgenda
        faction={faction.replace(/%20/g, " ").replace(/%22/g, '"')}
        agenda={agenda.replace(/%20/g, " ").replace(/%22/g, '"')}
        games={games}
        min={min}
      />
    )
  };

  const routeResult = useRoutes(routes);

  return (
    <div>
      <div>
        <div>
          <input
            type="date"
            value={start}
            onChange={e => setStart(e.target.value)}
          />{" "}
          Start Date
        </div>
        <div>
          <input
            type="date"
            value={end}
            onChange={e => setEnd(e.target.value)}
          />{" "}
          End Date
        </div>
        <div>
          <input
            type="number"
            value={min}
            onChange={e => setMin(e.target.value)}
          />{" "}
          Min Games Played
        </div>
      </div>
      {routeResult}
    </div>
  );
};

export default DecksReact;
