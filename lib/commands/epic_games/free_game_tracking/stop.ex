defmodule Bot.Commands.EpicGames.FreeGameTracking.Stop do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker

  def name(), do: "stop"

  @impl true
  def description(), do: "Stop tracking the weekly free game by Epic Games"

  @impl true
  def command(_interaction) do
    Tracker.stop()
    [content: "Tracking stopped."]
  end

  @impl true
  def type(), do: :slash
end
