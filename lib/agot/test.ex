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
end
