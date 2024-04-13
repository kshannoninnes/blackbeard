defmodule Bot.Services.Discord do
  require Logger

  alias Nostrum.Struct.Embed

  def post_free_game(channel_id, embed_info) do
    embed = %Embed{}
      |> Embed.put_title(embed_info[:title])
      |> Embed.put_thumbnail(embed_info[:image])
      |> Embed.put_description(embed_info[:description])
      |> Embed.put_url(embed_info[:url])
      |> IO.inspect

    Nostrum.Api.create_message(channel_id, %{content: "New free game available!", embed: embed})
  end
end
