defmodule Bot.Services.EpicGames.GameJsonParser do
  def parse_game_info(response) do
    info = response.body["data"]["Catalog"]["searchStore"]["elements"] |> get_current_free_game

    %{
      title: info["title"],
      id: info["id"],
      imageUrl: Enum.at(info["keyImages"], 2)["url"]
    }
  end

  defp get_current_free_game(games) do
    Enum.filter(games, fn game ->
      currentPrice = game["price"]["totalPrice"]["discountPrice"]
      originalPrice = game["price"]["totalPrice"]["originalPrice"]

      currentPrice == 0 and originalPrice > 0
    end)
    |> List.first
  end
end
