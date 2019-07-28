defmodule Agot.Cache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: AgotCache)
  end

  def init(state) do
    :ets.new(:exclude_cache, [:set, :public, :named_table])
    :ets.new(:players_cache, [:set, :public, :named_table])
    :ets.new(:updated_players_cache, [:set, :public, :named_table])
    {:ok, state}
  end

  def get_exclude(key) do
    GenServer.call(AgotCache, {:get, key, :exclude_cache})
  end

  def put_exclude(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :exclude_cache})
  end

  def delete_player(key) do
    GenServer.cast(AgotCache, {:delete, key, :players_cache})
  end

  def get_player(key) do
    GenServer.call(AgotCache, {:get, key, :players_cache})
  end

  def put_player(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :players_cache})
  end

  def delete_updated_player(key) do
    GenServer.cast(AgotCache, {:delete, key, :updated_players_cache})
  end

  def get_updated_player(key) do
    GenServer.call(AgotCache, {:get, key, :updated_players_cache})
  end

  def put_updated_player(key, data) do
    GenServer.cast(AgotCache, {:put, key, data, :updated_players_cache})
  end

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

  def handle_cast({:delete, key, table}, state) do
    :ets.delete(table, key)
    {:noreply, state}
  end
end
