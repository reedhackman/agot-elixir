import React, { useState, useEffect } from 'react'
import { useRoutes } from 'hookrouter'
import DecksFull from "./DecksFull.js"
import DecksFaction from './DecksFaction.js'
import DecksAgenda from './DecksAgenda.js'

const DecksReact = (props) => {
  const [games, setGames] = useState(props.games)
  const [start, setStart] = useState("")
  const [end, setEnd] = useState("")
  const [min, setMin] = useState(0)

  useEffect(() => {
    let dates = []
    props.games.forEach((game) => {
      dates.push(game.date)
    })
    dates.sort()
    setStart(dates[0])
    setEnd(dates[dates.length - 1])
  }, [])

  useEffect(() => {
    let games = []
    props.games.forEach((game) => {
      if (Date.parse(start) <= Date.parse(game.date) && Date.parse(game.date) <= Date.parse(end) ) {
        games.push(game)
      }
    })
    setGames(games)
  }, [start, end, min])

  const routes = {
    "/react/deck": () => <DecksFull games={games} min={min} />,
    "/react/deck/:faction": ({ faction }) => <DecksFaction faction={faction} games={games} />,
    "/react/deck/:faction/:agenda": ({ faction, agenda }) => <DecksAgenda faction={faction.replace(/%20/g, " ").replace(/%22/g, '"')} agenda={agenda.replace(/%20/g, " ").replace(/%22/g, '"')} games={games} min={min} />
  }

  const routeResult = useRoutes(routes)

  return(
    <div>
      <div>
        <div><input type="date" value={start} onChange={e => setStart(e.target.value)}/> Start Date</div>
        <div><input type="date" value={end} onChange={e => setEnd(e.target.value)}/> End Date</div>
        <div><input type="number" value={min} onChange={e => setMin(e.target.value)} /> Min Games Played</div>
      </div>
      {routeResult}
    </div>
  )
}

export default DecksReact
