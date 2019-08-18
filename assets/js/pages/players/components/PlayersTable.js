import React, { useState, useEffect } from "react";

const PlayersTable = props => {
  const [page, setPage] = useState(0);
  const [last, setLast] = useState(0);
  const [sortBy, setSortBy] = useState("name");
  const [asc, setAsc] = useState(false);
  const [input, setInput] = useState("");
  const [min, setMin] = useState(20);
  useEffect(() => {
    setPage(1);
    setLast(Math.ceil(props.players.length / 50));
  }, []);
};

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      page: 0,
      last: 0,
      sortby: "name",
      ascending: true,
      input: "",
      mingames: 20
    };
    this.handleNext = this.handleNext.bind(this);
    this.handlePrev = this.handlePrev.bind(this);
    this.handleFirst = this.handleFirst.bind(this);
    this.handleLast = this.handleLast.bind(this);
    this.handleMin = this.handleMin.bind(this);
    this.handleSearch = this.handleSearch.bind(this);
    this.handleSort = this.handleSort.bind(this);
  }
  handleNext() {
    if (this.state.page !== this.state.last) {
      document.body.scrollTop = 0; // For Safari
      document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
      this.setState({
        page: this.state.page + 1
      });
    }
  }
  handlePrev() {
    if (this.state.page !== 1) {
      document.body.scrollTop = 0; // For Safari
      document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
      this.setState({
        page: this.state.page - 1
      });
    }
  }
  handleFirst() {
    if (this.state.page !== 1) {
      document.body.scrollTop = 0; // For Safari
      document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
      this.setState({
        page: 1
      });
    }
  }
  handleLast() {
    if (this.state.page !== this.state.last) {
      document.body.scrollTop = 0; // For Safari
      document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
      this.setState({
        page: this.state.last
      });
    }
  }
  handleMin(event) {
    let count = 0;
    this.props.players.forEach(player => {
      if (player.wins + player.losses >= event.target.value) {
        count++;
      }
    });
    this.setState({
      mingames: event.target.value,
      page: 1,
      last: Math.ceil(count / 50)
    });
  }
  handleSearch(event) {
    let count = 0;
    this.props.players.forEach(player => {
      if (
        player.name.toLowerCase().indexOf(event.target.value.toLowerCase()) !==
        -1
      ) {
        count++;
      }
    });
    this.setState({
      input: event.target.value,
      page: 1,
      last: Math.ceil(count / 50)
    });
  }
  handleSort(event) {
    if (event.target.value === this.state.sortby) {
      this.setState({
        ascending: !this.state.ascending
      });
    } else {
      this.setState({
        sortby: event.target.value,
        ascending: true,
        page: 1
      });
    }
  }

  render() {
    let data = this.props.players;
    let rows = [];
    let list = [];
    let nav = (
      <div className="navbuttons">
        <button onClick={this.handleFirst} className="button-table button-left">
          First
        </button>
        <button onClick={this.handlePrev} className="button-table button-left">
          Prev
        </button>
        <span>
          Page {this.state.page} of {this.state.last}
        </span>
        <button onClick={this.handleNext} className="button-table button-right">
          Next
        </button>
        <button onClick={this.handleLast} className="button-table button-right">
          Last
        </button>
      </div>
    );
    let minbox = (
      <div className="minbox">
        <input
          type="number"
          value={this.state.mingames}
          onChange={this.handleMin}
        />
        <span> Minimum number of games played</span>
      </div>
    );
    let search = (
      <div className="searchbox">
        <input
          type="text"
          placeholder="Search By Player Name..."
          value={this.state.input}
          onChange={this.handleSearch}
          change="input"
        />
        <span> Search only players whose names match this string</span>
      </div>
    );
    data.sort((a, b) => {
      if (this.state.ascending === true) {
        if (this.state.sortby === "name") {
          if (a[this.state.sortby] > b[this.state.sortby]) {
            return 1;
          }
          if (b[this.state.sortby] > a[this.state.sortby]) {
            return -1;
          }
          return 0;
        }
        return b[this.state.sortby] - a[this.state.sortby];
      }
      if (this.state.sortby === "name") {
        if (a[this.state.sortby] > b[this.state.sortby]) {
          return -1;
        }
        if (b[this.state.sortby] > a[this.state.sortby]) {
          return 1;
        }
        return 0;
      }
      return a[this.state.sortby] - b[this.state.sortby];
    });
    data.forEach(player => {
      if (
        player.name.toLowerCase().indexOf(this.state.input.toLowerCase()) !==
          -1 &&
        player.played >= this.state.mingames
      ) {
        rows.push(player);
      }
    });
    let j = Math.max((this.state.page - 1) * 50, 0);
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
                <button
                  onClick={this.handleSort}
                  value="name"
                  className="button-table button-sort"
                >
                  Name
                </button>
              </th>
              <th className="players-table-rating">
                <button
                  onClick={this.handleSort}
                  value="rating"
                  className="button-table button-sort"
                >
                  Rating
                </button>
              </th>
              <th className="players-table-percent">
                <button
                  onClick={this.handleSort}
                  value="percent"
                  className="button-table button-sort"
                >
                  Win Percent
                </button>
              </th>
              <th className="players-table-played">
                <button
                  onClick={this.handleSort}
                  value="played"
                  className="button-table button-sort"
                >
                  Games Played
                </button>
              </th>
            </tr>
          </thead>
          <tbody>{list}</tbody>
        </table>
        <div className="table-nav-buttons">{nav}</div>
      </div>
    );
  }
}
