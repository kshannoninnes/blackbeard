defmodule Bot.Commands.Misc.EightBall do
  @behaviour Nosedrum.ApplicationCommand
  @responses [
    "It is certain.",
    "Reply hazy, try again.",
    "It is decidedly so.",
    "Ask again later",
    "Without a doubt.",
    "Better not tell you now.",
    "Yes definitely.",
    "Cannot predict now.",
    "You may rely on it.",
    "Concentrate and ask again.",
    "As I see it, yes.",
    "Don't count on it.",
    "Most likely.",
    "My reply is no.",
    "Outlook good.",
    "My sources say no.",
    "Yes.",
    "Outlook not so good.",
    "Signs point to yes.",
    "Very doubtful."
  ]

  alias Bot.Core.Logger

  def name(), do: "8ball"

  @impl true
  def description(), do: "Seek the wisdom of AI"

  @impl true
  def command(intr) do
    Logger.log_command(intr)
    [content: Enum.random(@responses)]
  end

  @impl true
  def type(), do: :slash

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "message",
        description: "Your question",
        required: true
      }
    ]
  end
end
