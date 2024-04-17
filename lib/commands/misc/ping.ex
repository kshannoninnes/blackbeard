defmodule Bot.Commands.Misc.Ping do
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Core.Logger

  def name(), do: "ping"

  @impl true
  def description(), do: "Ping the bot to check for lifesigns."

  @impl true
  def command(intr) do
    Logger.log_command(intr)
    [content: "pong!"]
  end

  @impl true
  def type(), do: :slash
end
