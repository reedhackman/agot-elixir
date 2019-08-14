import React from 'react'
import { BrowserRouter as Router, Route, Link } from "react-router-dom";
import DecksFull from "./DecksFull.js"
import DecksFaction from './DecksFaction.js'
import DecksAgenda from './DecksAgenda.js'

export default class extends React.Component{
  constructor(props){
    super(props)
    this.state = {
      games: this.props.games,
      start: "",
      end: "",
      min: 0,
      update: false
    }
  }
  componentDidMount(){
    let dates = []
    this.props.games.forEach((game) => {
      dates.push(game.date)
    })
    dates.sort()
    this.setState({
      start: dates[0],
      end: dates[dates.length - 1]
    })
  }
  componentDidUpdate(){
    if(this.state.update){
      let games = []
      this.props.games.forEach((game) => {
        if (Date.parse(this.state.start) <= Date.parse(game.date) && Date.parse(game.date) <= Date.parse(this.state.end) ) {
          games.push(game)
        }
      })
      this.setState({games: games, update: false})
    }
  }
  handleStart(e) {
    this.setState({start: e.target.value, update: true})
  }
  handleEnd(e) {
    this.setState({end: e.target.value, update: true})
  }
  setMin(e){
    this.setState({min: e.target.value, update: true})
  }
  render(){
    console.log(this.state)
    return(
      <div>
        <DateRange startChange={this.handleStart.bind(this)} endChange={this.handleEnd.bind(this)} start={this.state.start} end={this.state.end} min={this.state.min} setMin={this.setMin.bind(this)} />
        <Router>
          <Route exact path="/react/deck/" render={() => <DecksFull games={this.state.games} />} />
          <Route exact path="/react/deck/:faction" render={({ match }) => <DecksFaction match={match} games={this.state.games} />} />
          <Route exact path="/react/deck/:faction/:agenda" render={({ match }) => <DecksAgenda match={match} games={this.state.games} min={this.state.min} />} />
        </Router>
      </div>
    )
  }
}

const DateRange = ({start, end, min, startChange, endChange, setMin}) => (
  <div>
    <div><input type="date" value={start} onChange={startChange}/> Start Date</div>
    <div><input type="date" value={end} onChange={endChange}/> End Date</div>
    <div><input type="number" value={min} onChange={setMin} /> Min Games Played</div>
  </div>
)
