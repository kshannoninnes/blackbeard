defmodule Bot.Services.EpicGames.TrackerGenserv do
  use GenServer
  require Logger

  alias Bot.Services.EpicGames.Discord
  alias Bot.Services.EpicGames.GameJsonParser

  @url "https://store-site-backend-static-ipv4.ak.epicgames.com/freeGamesPromotions"
  @default_game_id -1

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    schedule_check()
    {:ok, @default_game_id}
  end

  def handle_info(:check_games, free_game_id) do
    free_game_id = update_free_game(free_game_id)
    schedule_check()
    {:noreply, free_game_id}
  end

  defp schedule_check() do
    Logger.debug("Scheduling a new game check")
    Process.send_after(self(), :check_games, :timer.seconds(15))
  end


  def update_free_game(game_id) do
    game_info = Req.get!(@url) |> GameJsonParser.parse_game_info()

    unless game_id == game_info[:id] do
      Logger.info("New free game found, posting in discord")
      Discord.send_embed(game_info[:title], game_info[:imageUrl])
    end

    game_info[:id]
  end

end
