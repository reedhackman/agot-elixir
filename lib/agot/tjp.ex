defmodule Agot.Tjp do
  alias Agot.Cache
  alias Agot.Repo
  alias Agot.Players

  def check_games_by_page(list \\ [], page \\ 1, i \\ 0) do
    url = "https://thejoustingpavilion.com/api/v3/games?page=" <> Integer.to_string(page)

    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        data = Poison.decode!(body)
        length = length(data)
        new_data = Enum.slice(data, i..length)
        IO.inspect(url <> " length: " <> Integer.to_string(length))
        if length === 50 do
          check_games_by_page(list ++ new_data, page + 1)
        else
          length
        end
    end
  end

  

end
