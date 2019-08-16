defmodule Agot.Test do
  def scrape(list \\ [], page \\ 1, i \\ 0) do
    url = "https://thejoustingpavilion.com/api/v3/games?page=" <> Integer.to_string(page)

    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        data = Poison.decode!(body)
        IO.inspect(url <> " length " <> Integer.to_string(length(data)))

        if length(data) === 50 do
          scrape(list ++ data, page + 1)
        else
          File.write("page.txt", Poison.encode!(page))
          File.write("position.txt", Poison.encode!(length(data)))
          File.write("data.txt", Poison.encode!(list ++ data))
        end
    end
  end

  def process do
    page = Poison.decode!(File.read!("page.txt")) |> IO.inspect()
    position = Poison.decode!(File.read!("position.txt")) |> IO.inspect()
    data = Poison.decode!(File.read!("data.txt")) |> IO.inspect()
    Agot.Misc.create_position()
    Agot.Analytica.process_all_games(data, page, position)
    Agot.Analytica.update_all_decks_three_months()
    Agot.Tjp.check_all_incomplete_age()
    Agot.Tjp.check_all_remaining_incomplete()
    Agot.Tjp.check_all_remaining_placements()
  end
end
