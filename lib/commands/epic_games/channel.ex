defmodule Bot.Commands.EpicGames.Channel do
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker
  alias Bot.Core.Logger

  def name(), do: "channel"

  @impl true
  def description(), do: "Change the channel that free game notifications are posted in"

  @impl true
  def command(intr) do
    Logger.log_command(intr)
    [%{name: "channel", value: channel}] = intr.data.options

    Tracker.update_channel(channel)

    [content: "Channel updated to #{channel}"]
  end

  @impl true
  def type(), do: :slash

  @impl true
  def options() do
    [
      %{
        type: :channel,
        name: "channel",
        description: "The channel to post free game notifications to",
        required: true
      }
    ]
  end
end
