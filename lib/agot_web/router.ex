defmodule AgotWeb.Router do
  use AgotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AgotWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/players/", PlayersController, :all
    get "/players/table", PlayersController, :table
    get "/players/:id", PlayersController, :specific

    get "/decks/", DecksController, :all
    get "/decks/:faction", DecksController, :faction
    get "/decks/:faction/:agenda", DecksController, :agenda
  end

  # Other scopes may use custom stacks.
  # scope "/api", AgotWeb do
  #   pipe_through :api
  # end
end
