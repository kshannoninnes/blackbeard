defmodule Bot.Services.EpicGames.Discord do
  require Logger

  alias Nostrum.Struct.Embed

  @channel_id 591208547316924416
  @embed_description "New free game on Epic Game Store!"

  def send_embed(title, image) do
    embed = %Embed{}
      |> Embed.put_title(title)
      |> Embed.put_thumbnail(image)
      |> Embed.put_description(@embed_description)

    Nostrum.Api.create_message(@channel_id, embed: embed)
  end
end
