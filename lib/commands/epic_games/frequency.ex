defmodule Bot.Commands.EpicGames.Frequency do
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker
  alias Bot.Core.Logger

  def name(), do: "frequency"

  @impl true
  def description(),
    do: "Change how often the tracker will check for new free games from Epic Games"

  @impl true
  def command(intr) do
    Logger.log_command(intr)
    [%{name: "frequency", value: frequency}] = intr.data.options

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
