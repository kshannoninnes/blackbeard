defmodule Bot.Commands.EpicGames.Frequency do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker

  def name(), do: "frequency"

  @impl true
  def description(), do: "Change how often the tracker will check for new free games from Epic Games"

  @impl true
  def command(interaction) do
    [%{name: "frequency", value: frequency}] = interaction.data.options

    Tracker.update_check_frequency(frequency)

    [content: "Frequency updated to every #{frequency} hours"]
  end

  @impl true
  def type(), do: :slash

  @impl true
  def options() do
    [
      %{
        type: :integer,
        name: "frequency",
        description: "How frequent should a check happen (in hours)",
        required: true
      }
    ]
  end
end
