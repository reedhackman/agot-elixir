defmodule Agot.Cache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: AgotCache)
  end

  def init(state) do
    :ets.new(:exclude_cache, [:set, :public, :named_table])
    :ets.new(:players_cache, [:set, :public, :named_table])
    :ets.new(:updated_players_cache, [:set, :public, :named_table])
    :ets.new(:decks_cache, [:set, :public, :named_table])
    :ets.new(:updated_decks_cache, [:set, :public, :named_table])
    :ets.new(:matchups_cache, [:set, :public, :named_table])
    :ets.new(:updated_matchups_cache, [:set, :public, :named_table])
    :ets.new(:top_ten_cache, [:set, :public, :named_table])
    {:ok, state}
  end

  # EXCLUDE
  def get_exclude(key) do
    GenServer.call(AgotCache, {:get, key, :exclude_cache})
  end

  def put_exclude(key, data) do
    GenServer.cast(AgotCache, {:put_exclude, key, data, :exclude_cache})
  end

  # PLAYERS
  def get_player(key) do
    GenServer.call(AgotCache, {:get, key, :players_cache})
  end

  def put_player(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :players_cache})
  end

  # UPDATED PLAYERS
  def delete_updated_player(key) do
    GenServer.cast(AgotCache, {:delete, key, :updated_players_cache})
  end

  def get_updated_player(key) do
    GenServer.call(AgotCache, {:get, key, :updated_players_cache})
  end

  def put_updated_player(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :updated_players_cache})
  end

  # DECKS
  def get_deck(key) do
    GenServer.call(AgotCache, {:get, key, :decks_cache})
  end

  def put_deck(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :decks_cache})
  end

  # UPDATED DECKS
  def delete_updated_deck(key) do
    GenServer.cast(AgotCache, {:delete, key, :updated_decks_cache})
  end

  def get_updated_deck(key) do
    GenServer.call(AgotCache, {:get, key, :updated_decks_cache})
  end

  def put_updated_deck(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :updated_decks_cache})
  end

  # MATCHUPS
  def get_matchup(key) do
    GenServer.call(AgotCache, {:get, key, :matchups_cache})
  end

  def put_matchup(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :matchups_cache})
  end

  # UPDATED MATCHUPS
  def delete_updated_matchup(key) do
    GenServer.cast(AgotCache, {:delete, key, :updated_matchups_cache})
  end

  def get_updated_matchup(key) do
    GenServer.call(AgotCache, {:get, key, :updated_matchups_cache})
  end

  def put_updated_matchup(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :updated_matchups_cache})
  end

  # TOP TEN
  def get_top_ten(key) do
    GenServer.call(AgotCache, {:get, key, :top_ten_cache})
  end

  def put_top_ten(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :top_ten_cache})
  end

  # HANDLERS
  def handle_call({:get, key, table}, _from, state) do
    reply =
      case :ets.lookup(table, key) do
        [] -> nil
        [{_key, data}] -> data
      end

    {:reply, reply, state}
  end

  def handle_cast({:put, key, data, table}, state) do
    :ets.insert(table, {key, data})
    {:noreply, state}
  end

  def handle_cast({:put_exclude, key, data, table}, state) do
    case :ets.lookup(table, key) do
      [] -> :ets.insert(table, {key, data})
      [{_key, _data}] -> nil
    end

    {:noreply, state}
  end

  def handle_cast({:delete, key, table}, state) do
    :ets.delete(table, key)
    {:noreply, state}
  end
end
