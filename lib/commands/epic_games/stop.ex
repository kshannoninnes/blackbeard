defmodule Bot.Commands.EpicGames.Stop do
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker
  alias Bot.Core.Logger

  def name(), do: "stop"

  @impl true
  def description(), do: "Stop tracking the weekly free game by Epic Games"

  @impl true
  def command(intr) do
    Logger.log_command(intr)
    Tracker.stop()
    [content: "Tracking stopped"]
  end

  @impl true
  def type(), do: :slash
end
