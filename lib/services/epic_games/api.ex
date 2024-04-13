defmodule Bot.Services.EpicGames.Api do
  alias Bot.Services.EpicGames.JsonParser

  @free_game_url "https://store-site-backend-static-ipv4.ak.epicgames.com/freeGamesPromotions"
  @base_page_url "https://store.epicgames.com/en-US/p"

  def get_free_game() do
    game_info = Req.get!(@free_game_url) |> JsonParser.parse_game_info()

    %{
      title: JsonParser.parse_game_title(game_info),
      image: JsonParser.parse_game_image_url(game_info),
      description: JsonParser.parse_game_description(game_info),
      url: "#{@base_page_url}/#{JsonParser.parse_game_page_slug(game_info)}"
    }
  end
end
