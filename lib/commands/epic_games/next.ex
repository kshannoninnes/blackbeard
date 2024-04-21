defmodule Bot.Commands.EpicGames.Next do
  @behaviour Nosedrum.ApplicationCommand

  alias Bot.Services.EpicGames.Tracker
  alias Bot.Core.Logger

  def name(), do: "next"

  @impl true
  def description(), do: "Check when the next game check will be"

  @impl true
  def command(intr) do
    Logger.log_command(intr)

    unix_ts = Tracker.get_next_check_unix_timestamp()

    response =
      case unix_ts do
        -1 ->
          "No check currently scheduled. Are you sure I'm tracking?"

        timestamp when timestamp > 0 ->
          next_check =
            DateTime.utc_now()
            |> DateTime.add(timestamp, :millisecond)
            |> DateTime.to_unix()

          "Next check scheduled for <t:#{next_check}>"

        _ ->
          "Error verifying next check"
      end

    [content: response]
  end

  @impl true
  def type(), do: :slash
end
