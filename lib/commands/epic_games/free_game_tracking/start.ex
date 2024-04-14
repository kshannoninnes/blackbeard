defmodule Bot.Commands.EpicGames.FreeGameTracking.Start do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker

  def name(), do: "start"

  @impl true
  def description(), do: "Start tracking the weekly free game by Epic Games"

  @impl true
  def command(interaction) do
    Tracker.start(interaction.channel_id)

    [content: "Tracking started in this channel. To change which channel I post in, type `/channel <channel_id>`"]
  end

  @impl true
  def type(), do: :slash
end
