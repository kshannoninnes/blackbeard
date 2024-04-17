defmodule Bot.Commands.EpicGames.Start do
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker
  alias Bot.Core.Logger

  def name(), do: "start"

  @impl true
  def description(), do: "Start tracking the weekly free game by Epic Games"

  @impl true
  def command(intr) do
    Logger.log_command(intr)
    Tracker.start(intr.channel_id)
    [content: "Tracking started"]
  end

  @impl true
  def type(), do: :slash
end
