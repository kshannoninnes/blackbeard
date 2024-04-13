defmodule Bot.Services.EpicGames.FreeGameTracker do
  use GenServer
  require Logger

  alias Bot.Services.Discord
  alias Bot.Services.EpicGames.Api

  @default_game_id -1
  @channel_id 591208547316924416

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
    game_info = Api.get_free_game()

    unless game_id == game_info[:id] do
      Logger.info("New free game found, posting in discord")
      Discord.post_free_game(@channel_id, %{
        title: game_info[:title],
        image: game_info[:image],
        description: game_info[:description],
        url: game_info[:url]
      })
    end

    game_info[:id]
  end

end
