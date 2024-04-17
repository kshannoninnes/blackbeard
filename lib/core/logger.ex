defmodule Bot.Core.Logger do
  require Logger

  def log_command(intr) do
    {:ok, channel} = Nostrum.Api.get_channel(intr.channel_id)
    Logger.info(
      "Received command '#{intr.data.name}' " <>
      "from user #{intr.user.username} (id: #{intr.user.id}) " <>
      "in channel #{channel.name} (id: #{intr.channel_id})")
  end
end
