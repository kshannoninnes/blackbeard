defmodule Bot.Services.EpicGames.Tracker do
  use GenServer
  require Logger

  alias Bot.Services.EpicGames.TrackerHelper

  @default_game_id -1
  @default_frequency 6

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  def init(_opts) do
    {:ok, %{game_id: @default_game_id, frequency: @default_frequency}}
  end

  def start(channel_id) do
    _ = GenServer.cast(__MODULE__, {:start, channel_id})
  end

  def stop() do
    _ = GenServer.cast(__MODULE__, {:stop, :normal})
  end

  def update_channel(channel_id) do
    _ = GenServer.cast(__MODULE__, {:update_channel, channel_id})
  end

  def update_check_frequency(freq) do
    _ = GenServer.cast(__MODULE__, {:update_freq, freq})
  end

  def get_next_check_unix_timestamp() do
    GenServer.call(__MODULE__, :next_check)
  end

  def handle_cast({:start, channel_id}, state) do
    state = Map.put_new(state, :channel_id, channel_id)
    Process.send_after(self(), :check_games, :timer.seconds(1))

    Logger.info("Started tracking, posting updates in channel #{channel_id}")

    {:noreply, state}
  end

  def handle_cast({:stop, reason}, state) do
    {:stop, reason, state}
  end

  def handle_cast({:update_channel, new_channel}, state) do
    state =  Map.put(state, :channel_id, new_channel)
    Logger.info("Updated channel id to #{new_channel}")

    {:noreply, state}
  end

  def handle_cast({:update_freq, new_freq}, state) do
    state = case state[:next_run] do
      nil ->
        Map.put(state, :frequency, new_freq)

      _ ->
        Process.cancel_timer(state[:next_run])
        Map.put(state, :frequency, new_freq)
        |> schedule_next_check()
    end

    Logger.debug("Updated the check frequency to #{new_freq} hours")

    {:noreply, state}
  end

  def handle_call(:next_check, _from, state) do
    next_check = case state[:next_run] do
      nil -> -1
      next_run_ref ->
        Process.read_timer(next_run_ref)
    end

    {:reply, next_check, state}
  end


  def handle_info(:check_games, state) do
    game_id = TrackerHelper.check_for_new_game(state[:game_id], state[:channel_id])

    state = Map.put(state, :game_id, game_id)
      |> schedule_next_check

    {:noreply, state}
  end

  defp schedule_next_check(state) do
    Logger.debug("Scheduling a new game check")
    next_run = Process.send_after(self(), :check_games, :timer.hours(state[:frequency]))
    Map.put(state, :next_run, next_run)
  end
end
