defmodule Bot.Services.EpicGames.Tracker do
  use GenServer
  require Logger

  alias Bot.Services.EpicGames.TrackerHelper

  @default_game_id -1
  @default_frequency 10

  def start(channel_id) do
    _ = GenServer.cast(__MODULE__, {:start, channel_id})
    Logger.info("Starting tracking, posting updates in channel #{channel_id}")
  end

  def stop() do
    _ = GenServer.cast(__MODULE__, {:stop, :normal})
  end

  def update_channel(channel_id) do
    _ = GenServer.cast(__MODULE__, {:update_channel, channel_id})
    Logger.info("Updated channel id to #{channel_id}")
  end

  def update_frequency(num_hours) do
    _ = GenServer.cast(__MODULE__, {:update_freq, num_hours})
    Logger.info("Updated the check frequency to #{num_hours}") # Should probably put all this "did the thing" logging in the actual functions
  end

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  def init(_opts), do: {:ok, nil}

  def handle_cast({:start, channel_id}, _state) do
    state = %{
      game_id: @default_game_id,
      frequency: @default_frequency,
      channel_id: channel_id
    }

    schedule_check(state[:frequency])
    {:noreply, state}
  end

  def handle_cast({:stop, reason}, state) do
    {:stop, reason, state}
  end

  def handle_cast({:update_channel, new_channel}, state) do
    {:noreply, Map.put(state, :channel_id, new_channel)}
  end

  def handle_cast({:update_freq, new_freq}, state) do
    {:noreply, Map.put(state, :frequency, new_freq)}
  end

  def handle_info(:check_games, state) do
    game_id = TrackerHelper.check_for_new_game(state[:game_id], state[:channel_id])
    state = Map.put(state, :game_id, game_id)

    schedule_check(state[:frequency])
    {:noreply, state}
  end

  def schedule_check(frequency) do
    Logger.debug("Scheduling a new game check")
    Process.send_after(self(), :check_games, :timer.seconds(frequency))
  end

end
