defmodule Bot.Core.Main do
  use Application

  # Entry Point
  def start(_type, _args) do
    children = [
      Nosedrum.Storage.Dispatcher,
      Bot.Core.Consumer,
      Bot.Services.EpicGames.Tracker
    ]

    options = [strategy: :one_for_one, name: Bot.Supervisor]
    Supervisor.start_link(children, options)
  end
end

defmodule Bot.Core.Consumer do
  use Nostrum.Consumer
  require Logger

  alias Bot.Core.CommandLoader
  alias Nosedrum.Storage.Dispatcher

  def handle_event({:READY, _, _}), do: CommandLoader.load_commands()
  def handle_event({:INTERACTION_CREATE, intr, _}), do: Dispatcher.handle_interaction(intr)

  def handle_event(_), do: :ok
end
