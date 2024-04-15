defmodule Bot.Services.EpicGames.TrackerHelper do
  require Logger

  alias Bot.Services.Discord
  alias Bot.Services.EpicGames.Api

  def check_for_new_game(game_id, channel_id) do
    game_info = Api.get_free_game()

    unless game_id == game_info[:id] do
      Logger.info("New free game found, posting in discord")
      Discord.post_free_game(channel_id, "New free game available!", %{
        title: game_info[:title],
        image: game_info[:image],
        description: game_info[:description],
        url: game_info[:url]
      })
    end

    game_info[:id]
  end

end
