defmodule Bot.Services.EpicGames.JsonParser do
  def parse_game_info(response) do
    response.body["data"]["Catalog"]["searchStore"]["elements"] |> get_current_free_game
  end

  def parse_game_id(game_info) do
    game_info["id"]
  end

  def parse_game_title(game_info) do
    game_info["title"]
  end

  def parse_game_image_url(game_info) do
    Enum.at(game_info["keyImages"], 2)["url"]
  end

  def parse_game_page_slug(game_info) do
    Enum.at(game_info["catalogNs"]["mappings"], 0)["pageSlug"]
  end

  def parse_game_description(game_info) do
    game_info["description"]
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
