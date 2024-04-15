defmodule Bot.Commands.EpicGames.Start do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker

  def name(), do: "start"

  @impl true
  def description(), do: "Start tracking the weekly free game by Epic Games"

  @impl true
  def command(interaction) do
    Tracker.start(interaction.channel_id)
    [content: "Tracking started."]
  end

  @impl true
  def type(), do: :slash
end
