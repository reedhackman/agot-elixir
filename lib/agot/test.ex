defmodule Agot.Test do
  def check_games_by_page(list \\ [], page \\ 1, i \\ 0) do
    url = "https://thejoustingpavilion.com/api/v3/games?page=" <> Integer.to_string(page)

    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        data = Poison.decode!(body)

        if page !== 4 do
          check_games_by_page(list ++ data, page + 1)
        else
          Agot.Analytica.process_from_test(list ++ data)
        end
    end
  end
end
