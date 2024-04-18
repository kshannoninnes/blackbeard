defmodule Bot.Core.CommandLoader do
  require Logger

  alias Nosedrum.Storage.Dispatcher

  @cmd_dir Path.join([File.cwd!, "lib", "commands"])
  @server_list Application.compile_env(:bot, :guild_ids)

  def load_commands() do
    load_command_plugins()
    |> register_commands()
    Logger.info("Commands loaded")
  end

  defp load_command_plugins() do
    Xfile.ls!(@cmd_dir, [recursive: true, filter: &String.ends_with?(&1, ".ex")])
    |> Enum.to_list()
    |> Enum.reduce([], fn file, acc ->
      [get_module(file)] ++ acc
    end)
  end

  defp register_commands(module_list) do
    Enum.each(module_list, fn module ->
      Dispatcher.queue_command(module.name, module)
      Logger.debug("Added module #{module} as command /#{module.name}")
    end)

    Enum.each(@server_list, fn server_id ->
      Dispatcher.process_queued_commands(server_id)
      Logger.debug("Successfully registered all commands to #{server_id}")
    end)
  end

  defp get_module(file) do
    pattern = ~r{defmodule \s+ ([^\s]+) }x
    contents = File.read!(file)

    Regex.scan(pattern, contents, capture: :all_but_first)
    |> List.flatten()
    |> List.first()
    |> string_to_module()
  end

  defp string_to_module(str), do: "Elixir." <> str |> String.to_existing_atom()
end
