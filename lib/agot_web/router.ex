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

    get "/", HomepageController, :index

    get "/player/", PlayerController, :all
    post "/player/", PlayerController, :search
    get "/player/:id", PlayerController, :specific

    get "/deck/", DeckController, :all
    get "/deck/:faction", DeckController, :faction
    get "/deck/:faction/:agenda", DeckController, :agenda

    get "/react/player", PlayerController, :react
    get "/react/deck", DeckController, :react
  end

  # Other scopes may use custom stacks.
  # scope "/api", AgotWeb do
  #   pipe_through :api
  # end
end
