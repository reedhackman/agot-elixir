import React, { useState, useEffect } from "react";

const PlayersTable = props => {
  const [page, setPage] = useState(0);
  const [last, setLast] = useState(0);
  const [sortBy, setSortBy] = useState("name");
  const [asc, setAsc] = useState(false);
  const [input, setInput] = useState("");
  const [min, setMin] = useState(0);
  useEffect(() => {
    handleMin(20);
  }, []);
  const handleSort = newSort => {
    if (newSort === sortBy) {
      setAsc(!asc);
    } else {
      setAsc(false);
      setSortBy(newSort);
    }
  };
  const handlePage = newPage => {
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
    setPage(newPage);
  };
  const handleSearch = newInput => {
    if (input !== newInput) {
      let count = 0;
      props.players.forEach(player => {
        if (
          player.name.toLowerCase().indexOf(newInput.toLowerCase()) !== -1 &&
          player.played >= min
        ) {
          count++;
        }
      });
      setPage(Math.min(1, count));
      setLast(Math.ceil(count / 50));
      setInput(newInput);
    }
  };
  const handleMin = newMin => {
    if (min !== newMin) {
      let count = 0;
      props.players.forEach(player => {
        if (
          player.played >= newMin &&
          player.name.toLowerCase().indexOf(input.toLowerCase()) !== -1
        ) {
          count++;
        }
      });
      setPage(Math.min(1, count));
      setLast(Math.ceil(count / 50));
      setMin(newMin);
    }
  };
  const data = props.players;
  let rows = [];
  let list = [];
  data.sort((a, b) => {
    if (asc) {
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
    }
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
  });
  data.forEach(player => {
    if (
      player.name.toLowerCase().indexOf(input.toLowerCase()) !== -1 &&
      player.played >= min
    ) {
      rows.push(player);
    }
  });
  let j = Math.max((page - 1) * 50, 0);
  let k = rows.length - j;
  for (let i = 0; i < Math.min(k, 50); i++) {
    let player = rows[j];
    list.push(
      <tr key={player.name} className="table-row">
        <td className="players-table-name">
          <a href={`/player/${player.id}`}>{player.name}</a>
        </td>
        <td className="players-table-rating">{Math.round(player.rating)}</td>
        <td className="players-table-percent">
          {(player.percent * 100).toFixed(1)}
        </td>
        <td className="players-table-played">{player.played}</td>
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
  const minbox = (
    <div className="minbox">
      <input
        type="number"
        value={min}
        onChange={e => handleMin(e.target.value)}
      />
      <span> Minimum number of games played</span>
    </div>
  );
  const search = (
    <div className="searchbox">
      <input
        type="text"
        placeholder="Search By Player Name..."
        value={input}
        onChange={e => handleSearch(e.target.value)}
        change="input"
      />
      <span> Search only players whose names match this string</span>
    </div>
  );
  return (
    <div className="table-wrapper">
      <div className="table-filter-box">
        {search}
        {minbox}
      </div>
      <table className="players-table">
        <thead>
          <tr>
            <th className="players-table-name">
              {sortBy === name ? (
                <div
                  onClick={() => handleSort("name")}
                  value="name"
                  className="reactButtonPrimary"
                >
                  {asc ? (
                    <i class="la la-sort-alpha-asc"></i>
                  ) : (
                    <i class="la la-sort-alpha-desc"></i>
                  )}
                  name
                </div>
              ) : (
                <div
                  onClick={() => handleSort("name")}
                  value="name"
                  className="reactButton"
                >
                  name
                </div>
              )}
            </th>
            <th className="players-table-rating">
              {sortBy === "rating" ? (
                <div
                  onClick={() => handleSort("rating")}
                  value="rating"
                  className="reactButtonPrimary"
                >
                  {asc ? (
                    <i class="la la-sort-numeric-asc"></i>
                  ) : (
                    <i class="la la-sort-numeric-desc"></i>
                  )}
                  Rating
                </div>
              ) : (
                <div
                  onClick={() => handleSort("rating")}
                  value="rating"
                  className="reactButton"
                >
                  Rating
                </div>
              )}
            </th>
            <th className="players-table-percent">
              {sortBy === "percent" ? (
                <div
                  onClick={() => handleSort("percent")}
                  value="percent"
                  className="reactButtonPrimary"
                >
                  {asc ? (
                    <i class="la la-sort-numeric-asc"></i>
                  ) : (
                    <i class="la la-sort-numeric-desc"></i>
                  )}
                  Win Percent
                </div>
              ) : (
                <div
                  onClick={() => handleSort("percent")}
                  value="percent"
                  className="reactButton"
                >
                  Win Percent
                </div>
              )}
            </th>
            <th className="players-table-played">
              {sortBy === "played" ? (
                <div
                  onClick={() => handleSort("played")}
                  value="played"
                  className="reactButtonPrimary"
                >
                  {asc ? (
                    <i class="la la-sort-numeric-asc"></i>
                  ) : (
                    <i class="la la-sort-numeric-desc"></i>
                  )}
                  Games Played
                </div>
              ) : (
                <div
                  onClick={() => handleSort("played")}
                  value="played"
                  className="reactButton"
                >
                  Games Played
                </div>
              )}
            </th>
          </tr>
        </thead>
        <tbody>{list}</tbody>
      </table>
      <div className="table-nav-buttons">{nav}</div>
    </div>
  );
};

export default PlayersTable;
