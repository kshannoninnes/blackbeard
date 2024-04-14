defmodule Bot.Core.CommandHandler do
  require Logger

  alias Nosedrum.Storage.Dispatcher

  @server_list Application.compile_env(:bot, :guild_ids)
  @cmd_root_path "Elixir.Bot.Commands"
  @plugin_filename "./command.list"

  def handle_command(interaction) do
    Logger.info("Received command '#{interaction.data.name}' from user #{interaction.user.username} (id: #{interaction.user.id})")
    Dispatcher.handle_interaction(interaction)
  end

  def register_commands() do
    case File.read(@plugin_filename) do
      {:ok, file_content} ->
        Logger.info("Command file loaded")
        String.split(file_content, "\n")
        |> map_to_modules
        |> register_modules_as_commands

      {:error, reason} ->
        Logger.error("Error reading command file: No commands loaded")
        Logger.debug("Could not load command file: #{reason}")
    end
  end

  defp map_to_modules(string_list) do
    Logger.debug("Beginning module conversion")
    Enum.map(string_list, fn str ->
      Logger.debug("Converting #{str} to module #{@cmd_root_path}.#{str}")
      Enum.join([@cmd_root_path, str], ".") |> String.to_existing_atom
    end)
  end

  defp register_modules_as_commands(module_list) do
    Enum.map(module_list, fn module ->
      Dispatcher.add_command(module.name, module, nil) # This nil represents server_id in the old add_command version
      Logger.debug("Added module #{module} as command /#{module.name}")
    end)

    Enum.each(@server_list, fn server_id ->
      Dispatcher.submit_command_registration(server_id)
      Logger.debug("Successfully registered all commands to #{server_id}")
    end)
  end
end
